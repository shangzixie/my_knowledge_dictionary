# http request

## multiple part to send file

```go
url := "https://sdk.photoroom.com/v1/segment"
// Open the file you want to upload
file, err := os.Open(filePath)
if err != nil {
 fmt.Println("Failed to open file:", err)
 return
}
defer file.Close()

// Create a buffer to store the form fields and file data
body := &bytes.Buffer{}
writer := multipart.NewWriter(body)

fileField, err := writer.CreateFormFile("image_file", file.Name())
if err != nil {
 fmt.Println("Failed to create form field:", err)
 return
}
_, err = io.Copy(fileField, file)
if err != nil {
 fmt.Println("Failed to copy file data:", err)
 return
}
err = writer.Close()
if err != nil {
 fmt.Println("Failed to close writer:", err)
 return
}
request, err := http.NewRequest("POST", "url", body)
if err != nil {
 fmt.Println("Failed to create request:", err)
 return
}
request.Header.Set("Content-Type", writer.FormDataContentType())

client := &http.Client{}
response, err := client.Do(request)
if err != nil {
 fmt.Println("Failed to send request:", err)
 return
}
defer response.Body.Close()

// Handle the response
fmt.Println("Response status:", response.Status)
```

## print response body

```go
	bodyBytes, err := io.ReadAll(resp.Body)
    if err != nil {
        log.Fatal(err)
    }
    bodyString := string(bodyBytes)
```
