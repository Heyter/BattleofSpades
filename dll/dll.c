#include "enet/enet.h"

ENetHost * client;
ENetAddress address;
ENetEvent event;
ENetPeer *peer;

int initenet(void) {
 return enet_initialize();
}

int createclient(int downstream, int upstream) {
 client = enet_host_create(NULL,1,2,downstream,upstream);
 enet_host_compress_with_range_coder(client);
 if(client == NULL) {
  return 0;
 }
 return 1;
}

int getversion(void) {
 return enet_linked_version();
}

int clientconnect(char* a, int port, int protocolversion) {
 enet_address_set_host(& address, a);
 address.port = port;
 peer = enet_host_connect (client, &address, 1, protocolversion);
 if(peer==NULL) {
  return 5000;
 }
 if (enet_host_service (client, & event, 5000) > 0 && event.type == ENET_EVENT_TYPE_CONNECT) {
  return 1;
 } else {
  return 5001;
 }
}

int clientcheckforevent(int waittime) {
 if(enet_host_service(client, & event, waittime)>0) {
  return event.type;
 } else {
  return 2000;
 }
}

void sendpacketdata(char* data, int len) {
 ENetPacket * packet = enet_packet_create(data,len,ENET_PACKET_FLAG_RELIABLE);
 enet_peer_send(peer, 0, packet);
}

int getping(void) {
 return peer -> lastRoundTripTime;
}

int getpacketlen(void) {
 return event.packet -> dataLength;
}

char* getpacketdata(void) {
 return event.packet -> data;
}

void destroypacket(void) {
  enet_packet_destroy(event.packet);
}

void clientdisconnect(void) {
 enet_peer_disconnect(peer, 0);
}

void resetpeer(void) { //call if connection failed
  enet_peer_reset (peer);
}

void destroyclient(void) { //call if host creation failed
 enet_host_destroy(client);
}

void deinitenet(void) {
 enet_deinitialize();
}