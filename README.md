# Week 4 – Opdracht 1: Ansible Webserver + Database Deployment HERKANSING

Ik had in eerste instantie geprobeerd via ESXI en daarin kon ik wel de de vm's aanmaken, maar ik kreeg op geen enkele manier een ssh verbinding met de gemaakte vm's, dus heb ik het uiteindelijk via azure gedaan. Overigens wil ik ook een video erbij uploaden als bewijsmateriaal van de gedeployde vms.



## Doel van de opdracht

Het doel van deze opdracht was het automatiseren van de configuratie van een eenvoudige webserver en databaseserver via Ansible. Hiervoor heb ik:

- Twee Ubuntu 20.04 VM’s gedeployed in **Microsoft Azure** met vaste IP-adressen.
- Een **Ansible inventory** gemaakt waarin duidelijk onderscheid is tussen de webserver en databaseserver.
- Rollen gemaakt voor `webserver` (Apache, PHP, PHP-MySQL) en `dbserver` (MySQL, db user).
- Gebruik gemaakt van **inventory variabelen**, `group_vars`, handlers en variabelen in het playbook.

**Alle onderdelen van deze opdracht zijn succesvol gelukt.**

---

## Stappen die ik heb gevolgd

### Stap 1: Terraform VM deployment in Azure
Ik heb Terraform gebruikt om automatisch twee VM’s te deployen:
- `webvm` op IP `10.0.1.10`
- `dbvm` op IP `10.0.1.11`

Ik heb handmatig de openbare IP’s opgezocht via de Azure Portal en deze gebruikt in de Ansible inventory.

### Stap 2: Inventory
De `inventory.yml` bevat twee groepen: `web` en `db`. Elk met een host, SSH user en key.

### Stap 3: Rollen aanmaken
Ik heb handmatig de Ansible-role structuur opgebouwd:

```bash
ansible-galaxy init roles/webserver
ansible-galaxy init roles/dbserver
In de webserver role installeer ik:

apache2

php

php-mysql

In de dbserver role installeer ik:

mysql-server

python3-pymysql

Een MySQL-gebruiker via community.mysql.mysql_user

Stap 4: Variabelen en handlers
In group_vars/db.yml heb ik mysql_user en mysql_password gedefinieerd.

Handlers worden gebruikt om Apache opnieuw te starten na installatie.
