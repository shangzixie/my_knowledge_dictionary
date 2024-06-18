# context package

## Introduction

When developing a large application, especially in server software, sometimes it's helpful for a function to know more about the environment it's being executed in aside from the information needed for a function to work on its own. For example, if a web server function is handling an HTTP request for a specific client, the function may only need to know which URL the client is requesting to serve the response. The function might only take that URL as a parameter. However, things can always happen when serving a response, such as the client disconnecting before receiving the response. If the function serving the response doesn't know the client disconnected, the server software may end up spending more computing time than it needs calculating a response that will never be used.

In this case, being aware of the context of the request, such as the client's connection status, allows the server to stop processing the request once the client disconnects. This saves valuable compute resources on a busy server and frees them up to handle another client's request. This type of information can also be helpful in other contexts where functions take time to execute, such as making database calls. To enable ubiquitous access to this type of information, Go has included a `context` package in its standard library.

In this tutorial, you will start by creating a Go program that uses a context within a function. Then, you will update that program to store additional data in the context and retrieve it from another function. Finally, you will use a context's ability to signal it's done to stop processing additional data.

## reference

[link](https://www.digitalocean.com/community/tutorials/how-to-use-contexts-in-go)