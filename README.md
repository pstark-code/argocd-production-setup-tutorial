# ArgoCD Production-ready Setup

Übung um schrittweise ein Production-Ready Setup mit ArgoCD aufzubauen und zu verstehen. Wir befinden uns hier in der Rolle des Operations/SysAdmin Teams mit extra Zugriff. 
Ein wichtiger Aspekt eines Production-ready Setup ist, dass individuelle Entwicklerteams nicht aus Versehen ausserhalb ihres Namespaces Sachen verändern können.

## Ziel

Kubernetes Cluster mit:
- GitOps-basierte Deployments mit ArgoCD
- Verschiedene Namespace für die verschiedenen Teams
- Separate Git repositories für das "Operations"-Team und für die verschiedenen Entwickler-Teams
- Separate Zugriffskontrollen und Sichten auf den Cluster
- Zwei Entwickler-Teams
- Ein Ops Team
- mind. eine Applikation pro Entwickler-Team deployt
- Infrastruktur, dazu gehört:
    - Ein Dashboard
    - Einen Ingress
    - Cert-manager
    - ... Was euch sonst noch begeistern mag.


## 1. Erste Schritte

Cluster aufsetzen. 

Ihr benötigt einen Cluster mit ArgoCD und CoreDNS installiert. Ich habe ein paar Beispieldateien für Kind in diesem Repo abgelegt. Wenn ihr es mit einer anderen Distribution machen wollt, steht euch das frei. 