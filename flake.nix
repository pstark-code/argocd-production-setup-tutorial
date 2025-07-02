{
  description = "An empty flake template that you can adapt to your own environment";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = inputs:
    let
      # The systems supported for this flake
      supportedSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forEachSupportedSystem = f: inputs.nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import inputs.nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }:
      let
        mkScript = name: text: (pkgs.writeShellScriptBin name text);
        aliasScripts = [
          # Define your scripts/aliases
          (mkScript "k" ''exec ${pkgs.kubecolor}/bin/kubecolor "''$@"'')
          (mkScript "kubectl" ''exec ${pkgs.kubecolor}/bin/kubecolor "''$@"'')
          (mkScript "shorten_path" ''echo "''${1:-''$PWD}" | sed "s:''$HOME:~:";'')
        ];
      in {
        default = pkgs.mkShell {

          # Set any environment variables for your dev shell
          env = {
            EDITOR = "nvim";
            KUBECOLOR_KUBECTL = ''${pkgs.kubectl}/bin/kubectl'';
            # TALOSCONFIG = (builtins.toString ./.) + ''/talosconfig'';
            # KUBECONFIG = (builtins.toString ./.) + ''/kubeconfig.yaml'';
            # FOO = builtins.toString ./.;

          };

          # Add any shell logic you want executed any time the environment is activated
          # Note: aliases don't work very well (or at all?) with direnv-activated shells.
          # Note2: functions also don't work.
          shellHook = ''

            alias kubectl='kubecolor'
            alias k='kubecolor'
            complete -o default -F __start_kubectl kubecolor
            complete -o default -F __start_kubectl k

            echo "beep boop from $PWD"
            ### for project-specific Kubernetes configuration files.
            export KUBECONFIG="$(pwd)/kubeconfig"
          '';

          # The Nix packages provided in the environment
          packages = aliasScripts ++ (with pkgs; [

            ##
            ## Basic Kubernetes Tools
            ##
            kubectl
            kubectx
            kubetail
            kube-linter
            kubelogin-oidc
            kubelogin
            kubernetes-helm

            ### Kubernetes TUIs
            k9s
            kdash
            kubetui

            ##
            ## Common k8s-distributions and extensions
            ##
            talosctl
            sops
            talhelper
            just
            # kubernetes
            # k0sctl
            # k3s
            # k3d
            kind
            minikube

            ### cluster-api
            clusterctl

            ### virtctl for kubevirt
            kubevirt
            (pkgs.symlinkJoin {
              name = "kubectl-virt";
              paths = with pkgs; [ kubevirt ];
              postBuild = "mv $out/bin/virtctl $out/bin/kubectl-virt";
            })

            ##
            ## Terraform/Opentofu
            ##
            tenv

            ##
            ## Quality of Life
            ##

            kubecolor
            # Colorizes kubectl output

            kubeconform
            # FAST Kubernetes manifests validator, with support for Custom Resources!

            # tubekit
            # Kubectl alternative with quick context switching

            krelay
            # Drop-in replacement for `kubectl port-forward` with some enhanced features

            kubectl-example
            # kubectl plugin for retrieving resource example YAMLs

            kubectl-klock
            # Kubectl plugin to render watch output in a more readable fashion

            # kubefetch
            # A neofetch-like tool to show info about your Kubernetes Cluster.

            # kubefwd
            # Bulk port forwarding Kubernetes services for local development

            # kube-prompt
            # [UPSTREAM DEAD] Interactive kubernetes client featuring auto-complete

            # kubeprompt
            # [Nix-centric] Kubernetes Shell prompt. Note: Integrates with direnv. 



            ##
            ## Managing your Kubeconfig(s)
            ##

            # kubetrim
            # Trim your KUBECONFIG automatically

            kubeval
            # Validate your Kubernetes configuration files

            kubecm
            # Manage your kubeconfig more easily


            ##
            ## Every day Operations
            ##

            kubectl-neat
            # Clean up Kubernetes yaml and json output to make it readable

            kubectl-graph
            # Kubectl plugin to visualize Kubernetes resources and relationships

            kubectl-explore
            # Better kubectl explain with the fuzzy finder

            kubectl-images
            # Show container images used in the cluster

            kubectl-ktop
            # Top-like tool for your Kubernetes clusters

            kubectl-tree
            # kubectl plugin to browse Kubernetes object hierarchies as a tree

            kubectl-view-allocations
            # kubectl plugin to list allocations (cpu, memory, gpu,... X utilization, requested, limit, allocatable,...)

            kubectl-view-secret
            # Kubernetes CLI plugin to decode Kubernetes secrets

            kube-state-metrics
            # Add-on agent to generate and expose k8s cluster-level metrics

            kube-capacity
            # A simple CLI that provides an overview of the resource requests, limits, and utilization in a Kubernetes cluster


            ##
            ## Kubernetes Resources Development/Maintenance
            ##

            kubernix
            # Single dependency Kubernetes clusters for local testing, experimenting and development


            ##
            ## In Depth Debugging
            ##

            kubectl-gadget
            # Collection of gadgets for troubleshooting Kubernetes applications using eBPF

            kubectl-doctor
            # kubectl cluster triage plugin for k8s

            kubeshark
            # API Traffic Viewer for Kubernetes

            kubespy
            # Tool to observe Kubernetes resources in real time

            kubexit
            # Command supervisor for coordinated Kubernetes pod container termination



            ##
            ## Security/Audit
            ##

            # kubeaudit
            # Audit tool for Kubernetes

            # kube-bench
            # Checks whether Kubernetes is deployed according to security best practices as defined in the CIS Kubernetes Benchmark

            # kubeclarity
            # Kubernetes runtime scanner

            # kubescape
            # Tool for testing if Kubernetes is deployed securely

            # kubesec
            # Security risk analysis tool for Kubernetes resources

            # kubestroyer
            # Kubernetes exploitation tool

            # kube-score
            # Kubernetes object analysis with recommendations for improved reliability and security

            # kube-hunter
            # Tool to search issues in Kubernetes clusters

            # kubent
            # Easily check your cluster for use of deprecated APIs

            # kubepug
            # Checks a Kubernetes cluster for objects using deprecated API versions



            ##
            ## Niche/Specialized Tools
            ##

            # kubectl-cnpg
            # Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes

            # kubectl-evict-pod
            # This plugin evicts the given pod and is useful for testing pod disruption budget rules

            # kubedock
            # Minimal implementation of the Docker API that will orchestrate containers on a Kubernetes cluster

            # kubedog
            # A tool to watch and follow Kubernetes resources in CI/CD deployment pipelines

            # kubefirst
            # Tool to create instant GitOps platforms that integrate some of the best tools in cloud native from scratch

            # kubemq-community
            # KubeMQ Community is the open-source version of KubeMQ, the Kubernetes native message broker

            # kubemqctl
            # Kubemqctl is a command line interface (CLI) for Kubemq Kubernetes Message Broker

            # kubeone
            # Automate cluster operations on all your cloud, on-prem, edge, and IoT environments

            # kube-router
            # All-in-one router, firewall and service proxy for Kubernetes

            # kubevpn
            # Create a VPN and connect to Kubernetes cluster network, access resources, and more

            # kubergrunt
            # Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl

            # kty
            # SSH Shell into your kubernetes cluster.

          ]);

        };
      });
    };
}
