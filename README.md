# Installation automatique de n8n et Ollama sur EC2

Ce dépôt contient un script d'installation automatique pour configurer n8n (via Docker) et Ollama sur une instance EC2 AWS.

## Prérequis

- Une instance EC2 AWS avec Ubuntu (recommandé : Ubuntu 22.04 LTS)
- Accès SSH à l'instance
- Droits sudo sur l'instance
- Au moins 4 Go de RAM recommandés (2 Go pour n8n + 2 Go pour Ollama)

## Installation

### Méthode 1 : Installation manuelle

1. Connectez-vous à votre instance EC2 via SSH
2. Clonez ce dépôt ou copiez le fichier `setup.sh`
3. Rendez le script exécutable :
   ```bash
   chmod +x setup.sh
   ```
4. Exécutez le script :
   ```bash
   ./setup.sh
   ```

### Méthode 2 : Installation via User Data

1. Lors de la création de votre instance EC2, dans la section "Advanced details"
2. Dans le champ "User data", copiez le contenu du fichier `setup.sh`
3. Lancez l'instance

## Vérification de l'installation

Une fois l'installation terminée :

- n8n sera accessible sur `http://<adresse-ip-ec2>:5678`
- Ollama sera accessible sur `http://<adresse-ip-ec2>:11434`

### Tester Ollama

Pour tester Ollama, vous pouvez utiliser la commande :
```bash
ollama run llama2
```

## Structure des données

- Les données de n8n sont persistées dans `/opt/n8n/data`
- Les modèles Ollama sont stockés dans `~/.ollama`
- Les deux services sont configurés pour redémarrer automatiquement en cas de problème

## Configuration de sécurité

Pour une utilisation en production, il est recommandé de :

1. Configurer un groupe de sécurité EC2 pour n'autoriser que les ports nécessaires (5678 pour n8n, 11434 pour Ollama)
2. Configurer un reverse proxy (comme Nginx) avec SSL
3. Mettre en place une authentification pour n8n
4. Configurer des sauvegardes régulières des dossiers `/opt/n8n/data` et `~/.ollama`
5. Configurer Docker pour utiliser un réseau isolé
6. Limiter l'accès à Ollama aux seules adresses IP nécessaires

## Support

Pour plus d'informations :
- [Documentation n8n](https://docs.n8n.io/)
- [Documentation Ollama](https://github.com/ollama/ollama)
- [Documentation Docker](https://docs.docker.com/) 