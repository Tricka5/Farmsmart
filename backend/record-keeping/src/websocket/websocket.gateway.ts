// src/websocket/websocket.gateway.ts
import { OnModuleInit } from '@nestjs/common';
import {
    WebSocketGateway,
    SubscribeMessage,
    MessageBody,
    OnGatewayConnection,
    OnGatewayDisconnect,
    WebSocketServer,
  } from '@nestjs/websockets';
  import { Socket } from 'socket.io';
  import {Server} from 'socket.io';
  
  @WebSocketGateway({
    cors: {
      origin: '*',  // Allow any origin, adjust for security in production
    },
  })
  export class WebSocketGatewayService
    implements OnGatewayConnection, OnGatewayDisconnect,OnModuleInit
  {
    private clients: Set<Socket> = new Set();
  
    // Called when a client connects
    handleConnection(client: Socket) {
      this.clients.add(client);
      console.log(`Client connected: ${client.id}`);
    }
  
    // Called when a client disconnects
    handleDisconnect(client: Socket) {
      this.clients.delete(client);
      console.log(`Client disconnected: ${client.id}`);
    }

    @WebSocketServer()
    server:Server;
    onModuleInit() {
        this.server.on('connection',(socket)=>{
            console.log(socket.id);
            console.log('connected');
        })
    }
  
    // Emit message to all connected clients
    @SubscribeMessage('triggerRefresh')
    handleRefreshRequest(@MessageBody() data: any): void {
      console.log('Received refresh request:', data);
  
      // Emit refresh event to all connected clients
      this.clients.forEach((client) => {
        client.emit('refresh', { message: data });
      });
    }
  }
  