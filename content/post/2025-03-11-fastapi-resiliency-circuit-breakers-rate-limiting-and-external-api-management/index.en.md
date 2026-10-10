---
title: 'FastAPI Resiliency: Circuit Breakers, Rate Limiting, and External API Management'
author: Aritra Biswas
date: '2025-03-11'
slug: fastapi-resiliency-circuit-breakers-rate-limiting-and-external-api-management
categories:
  - programming
tags:
  - LLM
  - GenAI
  - python
subtitle: ''
summary: ''
authors: []
lastmod: '2025-03-11T08:32:43+05:30'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

Let's assume that we are building a REST API service that depends on third-party APIs. To make the example more realistic, let's say we are building a RAG system that uses Tavily (a web search API) and LLMs. In this case, our app depends on these two external services. This is a common scenario in which our services rely on systems we have little control over. When building something like this, it is important to consider two things:

### __What will be the traffic our APIs will support:__

This depends on the API services we will invoke during execution. We should set our rate limit at or below the lowest rate limit among those services. This is an overall limit; we also need to apply per-user rate limits based on the number of concurrent users our app will support. What happens if one of the services returns a 429 and cannot serve more requests for a while? In many cases, when an LLM's TPM or RPM quota is exhausted, we continue to receive 429 responses until it can accept more requests. Let's break this down:

* Let's assume our app supports 10 concurrent users.
* The LLM we are using has an RPM limit of 2,700 and a TPM limit of 450k.
* The search API has an RPM limit of 1,000.
* We can make at most 1,000 calls per minute to each API before exceeding the search API's limit; after 2,700 requests, we would also exceed the LLM's RPM limit.
* Let's assume our app can serve 1,000 calls per minute.
* Each user is allowed to make 1,000 / 10 = 100 calls per minute.
* Here, we assume one user per IP address.

### __What will happen when consecutive failure occurs when 3rd party APIs are failing consecutively:__

Let's assume there is downtime or another issue with a third-party API, causing consecutive errors when our service calls it. In this scenario, it is better to fail gracefully and have a cooldown period. For example, if a service is down and returning 500 responses, receiving 1,000 or more such responses within one minute clearly indicates a problem. In this case, it is better to have a cooldown period of, say, one minute and notify the support team. This notification can also come from APIM or an API gateway.


### __Here is a minimalist example showing this scenario with `FastAPI` + `pybreaker` + `slowapi`:__

* A circuit breaker monitors the health of an external dependency, short-circuiting calls when failures exceed a threshold. Use a circuit breaker when you need to detect and isolate failures in external system calls, preventing cascading failures in your application. The circuit breaker is designed to detect and handle failures from external services. It prevents excessive effort on a failing external API by "opening" the circuit after a defined number of failures, thereby avoiding long wait times or cascading failures. You would use a circuit breaker to manage and handle issues when the third-party APIs start failing or become unreliable.
* A rate limiter restricts the rate of incoming requests from clients (or service calls) to avoid overload. Use rate limiting when you need to control the volume of incoming requests, protecting your server from overload or abuse. The rate limiter, on the other hand, regulates the rate of incoming requests to your service. It protects your system from abuse or overload by limiting how many requests can be processed in a given time period. You would use a rate limiter to protect your own service from being overwhelmed by too many incoming requests from clients.

### __Create local conda env:__


```bash
conda create -n ai_engine_api_env python=3.11 -y
conda activate ai_engine_api_env
pip install fastapi uvicorn pybreaker slowapi loguru
python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload 
```

### __Minimal FastAPI example:__

```python

import random
from fastapi import FastAPI, HTTPException, Request
import pybreaker
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.errors import RateLimitExceeded
from slowapi.util import get_remote_address
import uvicorn
from loguru import logger

# Configure loguru to add a log file with timestamp.
logger.add("api.log", format="{time:YYYY-MM-DD HH:mm:ss} | {level} | {message}", level="INFO")

# Create FastAPI app instance.
app = FastAPI()

# Setup rate limiter: 100 requests per minute per IP.
limiter = Limiter(key_func=get_remote_address, default_limits=["100/minute"])
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

# Configure separate circuit breakers for the two external services:
# Both fail after 2 consecutive errors and open the circuit for 10 seconds.
circuit_breaker_llm = pybreaker.CircuitBreaker(fail_max=2, reset_timeout=10)
circuit_breaker_web = pybreaker.CircuitBreaker(fail_max=2, reset_timeout=10)

def simulate_external_service(service_name: str):
    """
    Simulates a call to a 3rd party API service with the following probabilities:
      - 80% chance to succeed (HTTP 200).
      - 5% chance to fail with 500 Internal Server Error.
      - 5% chance to fail with 502 Bad Gateway.
      - 5% chance to fail with 503 Service Unavailable.
      - 5% chance to fail with 429 Too Many Requests.
    
    The service_name parameter is used for logging purposes.
    """
    chance = random.random()
    if chance < 0.05:
        logger.error(f"{service_name} API failed with status 500")
        raise Exception("500 Internal Server Error - simulated by " + service_name + " API")
    elif chance < 0.10:
        logger.error(f"{service_name} API failed with status 502")
        raise Exception("502 Bad Gateway - simulated by " + service_name + " API")
    elif chance < 0.15:
        logger.error(f"{service_name} API failed with status 503")
        raise Exception("503 Service Unavailable - simulated by " + service_name + " API")
    elif chance < 0.20:
        logger.error(f"{service_name} API failed with status 429")
        raise Exception("429 Too Many Requests - simulated by " + service_name + " API")
    else:
        return {"data": f"Successful response from {service_name} API", "status": 200}

# Wrap each external service call with its corresponding circuit breaker.

@circuit_breaker_llm
def fake_llm_call():
    """
    Simulates a call to an LLM API service.
    """
    return simulate_external_service("LLM")

@circuit_breaker_web
def fake_web_search():
    """
    Simulates a call to a web search API service.
    """
    return simulate_external_service("Web Search")

@app.get("/rag")
@limiter.limit("100/minute")
def rag_endpoint(request: Request):
    """
    RAG endpoint that aggregates responses from two external services:
      - A fake web search API.
      - A fake LLM API.
    
    Both services are protected with circuit breakers (fail after 2 errors, open for 10 seconds)
    and the endpoint is rate limited to 100 requests per minute per IP.
    
    In case any of the external services fails, the error is logged with a timestamp and an
    appropriate HTTP status code is returned to the client.
    """
    responses = {}

    # Attempt to call the Web Search API.
    try:
        web_response = fake_web_search()
        responses["web_search"] = web_response
    except pybreaker.CircuitBreakerError:
        msg = "Web Search API temporarily unavailable due to previous errors (circuit open)"
        logger.error(msg)
        raise HTTPException(status_code=503, detail=msg)
    except Exception as error:
        logger.error(f"Error calling Web Search API: {error}")
        error_msg = str(error)
        if "500" in error_msg:
            raise HTTPException(status_code=500, detail=error_msg)
        elif "502" in error_msg:
            raise HTTPException(status_code=502, detail=error_msg)
        elif "503" in error_msg:
            raise HTTPException(status_code=503, detail=error_msg)
        elif "429" in error_msg:
            raise HTTPException(status_code=429, detail=error_msg)
        else:
            raise HTTPException(status_code=502, detail="Bad Gateway: error from Web Search API")

    # Attempt to call the LLM API.
    try:
        llm_response = fake_llm_call()
        responses["llm"] = llm_response
    except pybreaker.CircuitBreakerError:
        msg = "LLM API temporarily unavailable due to previous errors (circuit open)"
        logger.error(msg)
        raise HTTPException(status_code=503, detail=msg)
    except Exception as error:
        logger.error(f"Error calling LLM API: {error}")
        error_msg = str(error)
        if "500" in error_msg:
            raise HTTPException(status_code=500, detail=error_msg)
        elif "502" in error_msg:
            raise HTTPException(status_code=502, detail=error_msg)
        elif "503" in error_msg:
            raise HTTPException(status_code=503, detail=error_msg)
        elif "429" in error_msg:
            raise HTTPException(status_code=429, detail=error_msg)
        else:
            raise HTTPException(status_code=502, detail="Bad Gateway: error from LLM API")

    return {
        "status": 200,
        "message": "Aggregated response from external services",
        "data": responses
    }

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
```


Both techniques can be used together to create a robust service that protects both the server resources (via rate limiting) and the overall system stability (via the circuit breaker). They are not strictly dependent on one another (i.e., one doesn’t inherently require the other to function), but implementing both can significantly enhance the resiliency and stability of your service. Each pattern applies to different parts of your system architecture: circuit breakers handle instability from dependencies, and rate limiters manage load and prevent overload.

### __Error handling__

#### __Common API Status Codes__

When building or consuming RESTful APIs, it's important to understand the HTTP status codes that indicate the outcome of a request. Below is a list of common status codes and their typical meanings:

##### 2xx Success
- **200 OK**  
  Indicates that the request was successful and the server returned the requested data.

- **201 Created**  
  Indicates that a new resource has been created as a result of the request. Often used in response to POST requests.

- **204 No Content**  
  Indicates that the request was successful, but there is no content to send in the response. Common for DELETE requests.

##### 3xx Redirection
- **301 Moved Permanently**  
  Indicates that the requested resource has been permanently moved to a new URL.

- **302 Found** (or **Temporary Redirect**)  
  Indicates that the requested resource is temporarily located at a different URL.

##### 4xx Client Error
- **400 Bad Request**  
  Indicates that the server could not understand the request due to malformed syntax. The client should not repeat the request without modifications.

- **401 Unauthorized**  
  Indicates that the request requires user authentication. Often used when authentication credentials are missing or invalid.

- **403 Forbidden**  
  Indicates that the server understood the request, but refuses to authorize it. This typically means that the client does not have the necessary permissions.

- **404 Not Found**  
  Indicates that the requested resource could not be found on the server.

- **409 Conflict**  
  Indicates that the request could not be completed due to a conflict with the current state of the resource.

- **429 Too Many Requests**  
  Indicates that the client has sent too many requests in a given amount of time ("rate limiting").

##### 5xx Server Error
- **500 Internal Server Error**  
  Indicates that the server encountered an unexpected condition that prevented it from fulfilling the request.

- **502 Bad Gateway**  
  Indicates that the server, while acting as a gateway or proxy, received an invalid response from an inbound server.

- **503 Service Unavailable**  
  Indicates that the server is currently unable to handle the request due to temporary overloading or maintenance. This suggests a temporary condition that may be resolved after some time.

- **504 Gateway Timeout**  
  Indicates that the server, while acting as a gateway or proxy, did not receive a timely response from an upstream server.

#### Explanation of Handled Status Codes in the App

In the sample FastAPI application, we specifically handle the following HTTP status codes originating from the external services:
  
- **500 Internal Server Error:**  
  This code indicates that something went wrong on the server side of the external service. It is a generic error used when no more specific error message is applicable. By catching this, the app knows there's an issue internally at the dependency.

- **502 Bad Gateway:**  
  This status code means that our API, acting as a gateway or proxy to the external service, received an invalid response from the upstream server. It typically indicates a problem with communication between our API and the external service.

- **503 Service Unavailable:**  
  This code indicates that the external service is currently overloaded or down for maintenance. By handling this error, we can quickly inform the client that the dependency is not available and avoid indefinite waiting on a response.

- **429 Too Many Requests:**  
  This status code is returned when the external service is rate limiting our requests. Handling this response allows our app to identify when the external service is overwhelmed or when our usage exceeds their rate limits, and take action (i.e., provide an appropriate error message).

#### Why Only These Codes?

1. **Focused Error Handling:**  
   The sample app aims to simulate realistic scenarios where the external dependency fails due to server-side issues (500 series errors) or rate limiting (429). These errors are critical because they indicate problems beyond simple request formatting or client-side issues.

2. **Simplification:**  
   The example is designed to demonstrate the integration of rate limiting and circuit breakers with minimal complexity. Handling only the most common and informative errors (500, 502, 503, and 429) keeps the code straightforward and focused on the primary issues encountered with unstable external services.

3. **Relevance to Dependencies:**  
   When dealing with external APIs, it’s common to see transient failures (like 500, 502, and 503) or rate-limit-specific failures (like 429). Client errors (e.g., 400 Bad Request or 404 Not Found) typically indicate problems with the API call or resource identification and are less relevant when determining the health of an external dependency.

4. **Fallback Scenario:**  
   For any other unexpected errors or status codes, the application defaults to a 502 Bad Gateway response. This generic error indicates that while the call to the external service failed, the failure doesn't match any of our explicitly handled cases. It signals to the consumer that something went wrong upstream, even if we don't have detailed handling for every possible error code.

### Summary

By handling only these key status codes (500, 502, 503, and 429), the app remains both focused and efficient in detecting issues with external services. These codes provide clear signals for typical failure modes in a dependent API, ensuring that the circuit breaker can manage failures and that clients receive meaningful error messages regarding the state of external dependencies.
