# Suburban-SOC Network Topology & Traffic Monitoring Scope

Based on the project requirements, the monitoring scope for the **Suburban-SOC pipeline** specifically includes the **internal traffic from the mesh nodes**. This allows the SOC to detect lateral movement, internal device communications, and suspicious behavior happening *behind* the gateway.

Here is a visual representation of how that layout works, identifying exactly where traffic is being captured relative to the rest of the network elements.

> [!TIP]
> By capturing traffic at the local mesh nodes (or centrally at the gateway tracking internal node interfaces), the SOC gains heavy visibility into direct device-to-device communications that wouldn't be seen if we only monitored boundary HTTP outbound traffic to the ISP.

```mermaid
graph TD
    %% Define Styles
    classDef attacker fill:#ffcccc,stroke:#ff0000,stroke-width:2px;
    classDef meshNode fill:#e1f5fe,stroke:#0288d1,stroke-width:2px;
    classDef gateway fill:#ffecb3,stroke:#ffa000,stroke-width:2px;
    classDef soc fill:#c8e6c9,stroke:#388e3c,stroke-width:2px;
    classDef pipeline fill:#eeeeee,stroke:#616161,stroke-width:2px,stroke-dasharray: 5 5;
    classDef client fill:#f5f5f5,stroke:#9e9e9e,stroke-width:1px;

    %% External
    ISP((Internet / ISP))
    
    %% Gateway
    Gateway["Main Mesh Router<br/>(Gateway & Controller)"]:::gateway
    
    %% Mesh Nodes
    subgraph "Suburban Internal Mesh Network"
        Node1["Mesh Node 1"]:::meshNode
        Node2["Mesh Node 2"]:::meshNode
        Node3["...Mesh Nodes up to 6"]:::meshNode
    end
    
    %% End Devices
    Client1["IoT Camera"]:::client
    Client2["Smart TV"]:::client
    Client3["Laptops & PCs"]:::client
    Client4["Smartphones"]:::client
    
    %% SOC Components
    subgraph "Suburban-SOC Pipeline"
        Zeek["Zeek Container<br/>(PCAP -> JSON)"]:::soc
        Filebeat["Filebeat<br/>(Log Shipper)"]:::soc
        ELK["ELK Stack<br/>(Logstash, Elastic, Kibana)"]:::soc
    end
    
    %% Connections (Physical Traffic Flow)
    ISP <==> Gateway
    Gateway <==>|Core Routing| Node1
    Gateway <==>|Core Routing| Node2
    Gateway <==>|Core Routing| Node3
    
    Node1 <--> Client1
    Node1 <--> Client2
    
    Node2 <--> Client3
    Node3 <--> Client4
    
    %% Traffic Capturing
    Node1 -.->|Captures Internal Traffic| Zeek
    Node2 -.->|Captures Internal Traffic| Zeek
    Node3 -.->|Captures Internal Traffic| Zeek
    Gateway -.->|Captures Outbound & Core| Zeek
    
    %% Pipeline Flow
    Zeek == JSON Logs ==> Filebeat
    Filebeat == Shipped via 5044 ==> ELK

```

### Resolution for Issue #8 (Baseline Traffic Monitoring Scope)

1. **Traffic Included:** All internal traffic passing bounds between connected clients (laptops, IoT cameras) and their respective mesh AP nodes, as well as traffic between nodes and the primary gateway.
2. **Advantages:** Highly advantageous for identifying compromised smart devices (IoT) launching internal attacks against other devices on your home network.
3. **Implications for Zeek:** Zeek will process a high percentage of raw PCAPs. To avoid dropping packets, performance and log rotation will become important factors later on, but the enhanced visibility is a necessary trade-off for a true SOC setup.
