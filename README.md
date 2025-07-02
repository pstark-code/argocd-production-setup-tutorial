# ArgoCD Production-ready Setup

Übung um schrittweise ein Production-Ready Setup mit ArgoCD aufzubauen und zu verstehen. Wir befinden uns hier in der Rolle des Operations/SysAdmin Teams mit extra Zugriff. 

Ein wichtiger Aspekt eines Production-ready Setup ist, dass individuelle Entwicklerteams nicht aus Versehen ausserhalb ihres Namespaces Sachen verändern können.

## Ziel

Ein oder mehrere Kubernetes Cluster mit Basis-Infrastruktur und verschiedenen Kundenapplikationen. Davon möglichst viel per GitOps (ArgoCD) deployed. 

Es soll auch ein nachhaltiges Authentifizierungs- und Authorisierungskonzept vorhanden sein, um den Mehraufwand für das Operationsteam zu minimieren. Die Entwickler sollen ihre Namespaces selber verwalten, aber nicht erstellen oder löschen können.

## Details Etappe 1 - Cluster Setup

Kubernetes Cluster mit:
- ArgoCD
- Ingress
- Cert-manager

Bonus (das könnt ihr auch später noch jederzeit machen):
- Automatisierter Cluster Aufbau
  - Bash/Ansible/Terraform/o.ä.
- Dashboard, z.b:
  - [Standard Kubernetes Dashboard](https://github.com/kubernetes/dashboard/blob/master/README.md#installation)
  - [Headlamp](https://headlamp.dev/docs/latest/installation/in-cluster/)
  - [YAKD - Yet another Kubernetes Dashboard](https://github.com/manusa/yakd)
- Monitoring
  - kube-prometheus-stack

Ein Beispiel um schnell in die Gänge zu kommen findet ihr im Ordner [01-beispiel-cluster](./01-beispiel-cluster).


## Details Etappe 2 - 

- GitOps-basierte Deployments mit ArgoCD
- Verschiedene Namespaces für die verschiedenen Teams (Vielleicht auch mehrere Namespaces pro Team?)
- Separate Git repositories für das "Operations"-Team und für die verschiedenen Entwickler-Teams
- Separate Zugriffskontrollen und Sichten auf den Cluster
- Mindestens zwei Entwickler-Teams
- Mindestens ein Operations Team
- mind. eine Applikation pro Entwickler-Team per ArgoCD deployed

