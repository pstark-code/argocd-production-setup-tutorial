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

### Die involvierten Parteien:

- Operations-Team "Ops"
  - Das sind wir
- Entwickler-Team "Gophers"
- Entwickler-Team "Pythonistas"

**"Ops"**

Als Operations Team haben wir vollen Zugriff auf den Cluster, mit allen Vor- und Nachteilen die das mit sich bringt.

Die Schattenseite des Zugriffs wollen wir etwas ausgleichen indem wir möglichst viel von der Clusterinfrastruktur auch per ArgoCD ausrollen, damit wir nur im äussersten Notfall Hand anlegen müssen. 

**Gophers und Pythonistas** 

Die zwei Teams entwicklen Software, die auf Kubernetes deployed werden soll. Sie kennen Kubernetes gut genug, dass sie ihre Helm charts warten können. 

Aber sie sollten keinen Admin-Zugriff haben, damit allfällige Fehler nicht zu Fehlern an der Infrastruktur führen können.

### Namespaces

Es kann sich lohnen, Namespaces mit Präfixen oder Suffixen zu versehen, damit sie in ArgoCD gematcht und der Zugriff entsprechend gesteuert werden kann.


### Eine Basis für das ArgoCD Git Repository:

Um ein "App-of-Apps" pattern aufzuziehen, benötigt es immer irgendwo eine Basis, die anfänglich "von Hand" eingepflegt werden muss. Bei Puzzle sieht das etwa so aus:

```yaml
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: production-cluster-argo-apps
  namespace: argocd
spec:
  destination:
    namespace: kube-system
    name: in-cluster
  project: pitc-sys
  source:
    helm:
      valueFiles:
      - "production-cluster-values.yaml"
    path: .
    repoURL: https://gitlab.puzzle.ch/abteilung/gruppe/production/argo-apps.git
    targetRevision: HEAD
  syncPolicy:
    automated:
      selfHeal: true
```


