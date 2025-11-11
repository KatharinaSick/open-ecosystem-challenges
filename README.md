# Open Ecosystem Challenges

```
01-gitops-delivery/
├── README.md                  # Challenge instructions and story
├── init.sh 
├── manifests/                 # Argo CD ApplicationSet, app manifests, etc.
│   ├── applicationset.yaml
│   ├── staging/
│   │   └── kustomization.yaml
│   └── prod/
│       └── kustomization.yaml
├── app/                       # Sample app source code (if needed)
│   └── echo-web/
├── tests/                     # Smoke test scripts
│   └── smoke-test.sh
├── assets/                    # Diagrams, screenshots, etc.
│   └── architecture.png
└── .github/
    └── workflows/
        └── verify.yml         # GitHub Actions for submission verification
```