
#include <iostream>
#include <string>
#include <stdio.h>
#include <vector>
#include "HostPortUDP.h"
//#include "sockpp/udp_socket.h"
//#include "sockpp/version.h"


unsigned short port = 9876;
const char ip[] = "192.168.1.255";


//sockpp::socket_initializer sockInit;
//sockpp::udp_socket client;

HostPortUDP wifi_port;
std::vector<float> data(32);

int main() {
    
    if (!wifi_port.begin(ip, port, HostPortUDP::HEADER, HostPortUDP::TERMINATOR, 10000)) {
        printf("Unable to connect\n");
        return -1;
    }
    if (!wifi_port.isInit()) {
        printf("Issue in device connection\n");
        return -1;
    }

    printf("Connected\n");
    while (1) {
        if (wifi_port.read((unsigned char*) data.data(), 4*32)) {
            for (int i = 0; i < 32; ++i) {
                printf("%.3f\t", data[i]);
            }
            printf("\n");
        }

    }

/*
    int enable = 1;
    if (client.set_option(SOL_SOCKET,SO_BROADCAST,&enable,sizeof(enable)) == -1) {
        std::cout << "Failed to set opt\n";
    } else std::cout << "Set opt\n";
    client.bind({ip, port});
    if (!client) {
        printf("Unable to connect\n");
        return -1;
    }

    printf("Connected\n");
    std::cout << std::hex;
    while (1) {
        uint8_t c[256];
        size_t len = client.recv(c, 256);
        for (int i = 0; i < (len); ++i) {
            std::cout << (int) c[i];

        }
        std::cout <<  std::endl;
        memset(c,0,256);
    }*/

    return 0;
}