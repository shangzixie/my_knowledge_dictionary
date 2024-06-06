# grpc

## basic

RPC is used to call other processes on remote systems as if the process were a local system. A procedure call is also sometimes known as a function call or a subroutine call.

It does this using a client-server model. The requesting program is called a client, while the service-providing program is called the server.

### proto

firstly, need to define a service in `helloworld.proto`

```go
syntax = "proto3";

option java_multiple_files = true;
option java_package = "io.grpc.examples.helloworld";
option java_outer_classname = "HelloWorldProto";

package helloworld;

// The greeting service definition.
service Greeter {
  // Sends a greeting
  rpc SayHello (HelloRequest) returns (HelloReply) {}
}

// The request message containing the user's name.
message HelloRequest {
  string name = 1;
}

// The response message containing the greetings
message HelloReply {
  string message = 1;
}
```

we define a service `Greeter` and there a method in it, called `SayHello`, receive `HelloRequest` type and return `HelloReply` type;

Then define type ``HelloRequest` and `HelloReply`

then we produce `helloword.pb.go` file and there is some methods in it:

```go
func NewGreeterClient(cc *grpc.ClientConn) GreeterClient {
    return &greeterClient{cc}
}

func RegisterGreeterServer(s *grpc.Server, srv GreeterServer) {
    s.RegisterService(&_Greeter_serviceDesc, srv)
}
```

### agent

```go
func main() {
    // Set up a connection to the server.
    conn, err := grpc.Dial(*addr, grpc.WithInsecure())
    if err != nil {
        log.Fatalf("did not connect: %v", err)
    }
    defer conn.Close()
    // new a client Greeter service instance
    c := pb.NewGreeterClient(conn)
    ctx := context.Background()
    // Contact the server and print out its response.
    name := "world"
    r, err := c.SayHello(ctx, &pb.HelloRequest{Name: name})
    if err != nil {
        fmt.Printf("Greeting: %s", r.Message)
    }
}
```

### server

```go
// server is used to implement helloworld.GreeterServer.
type server struct {
    helloworld.UnimplementedGreeterServer
}

// SayHello implements helloworld.GreeterServer
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
    log.Printf("Handling SayHello request [%v] with context %v", in, ctx)
    return &pb.HelloReply{Message: "Hello " + in.Name}, nil
}

func main() {
    addr := flag.String("addr", ":50051", "Network host:port to listen on for gRPC connections.")
    // build a server and listen port *addr
    lis, err := net.Listen("tcp", *addr)
    if err != nil {
        log.Fatalf("failed to listen: %v", err)
    }
    // register Greeter service server
    s := grpc.NewServer()
    pb.RegisterGreeterServer(s, &server{})
    // Register reflection service on gRPC server.
    reflection.Register(s)
    if err := s.Serve(lis); err != nil {
        log.Fatalf("failed to serve: %v", err)
    }
}
```
