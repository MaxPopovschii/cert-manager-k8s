# Contributing to Kubernetes Certificate Management System

## 🎯 Guidelines

### Creating Issues
- Check existing issues before creating a new one
- Use issue templates when available
- Provide clear reproduction steps for bugs

### Pull Requests
1. Fork the repository
2. Create a new branch
3. Make your changes
4. Write/update tests
5. Ensure all tests pass
6. Submit PR with clear description

### Commit Messages
Follow conventional commits format:
- feat: new feature
- fix: bug fix
- docs: documentation changes
- style: formatting
- refactor: code restructuring
- test: adding tests
- chore: maintenance

## 🔧 Development Setup

1. Clone the repository:
```bash
git clone https://github.com/MaxPopovschii/cert-manager-k8s.git
cd cert-manager-k8s
```

2. Install prerequisites:
- Kubernetes cluster (v1.19+)
- kubectl
- cert-manager

3. Apply configurations:
```bash
kubectl apply -f src/ca/
kubectl apply -f src/certificates/
```

## 🧪 Testing

Run tests:
```bash
kubectl get certificates -n cert-manager
kubectl describe certificate admin-cert -n cert-manager
```

## 📝 Documentation

- Update README.md for significant changes
- Document new features
- Include code examples

## 🤝 Code of Conduct

- Be respectful and inclusive
- Follow project conventions
- Help others when possible

## ❓ Questions?

Open an issue or contact the maintainers.
