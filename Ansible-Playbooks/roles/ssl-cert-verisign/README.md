# HOW TO USE THIS ROLE:
#Requires the Cablevision written Ansible dependency: verisign_ssl_cert_purchase

### This role expects the following variables to be set:
* key_file		OUTPUT FILE FOR KEY (full path)
* csr_file		OUTPUT FILE FOR CSR (full path)
* cert_file		OUTPUT FILE FOR CERT (full path)
* fqdn			THIS IS THE WEBSITE FQDN. EXAMPLE: mywebapp.cablevision.com
* ou			ORGANIZATIONAL UNIT (Ex: Enterprise IT)
* challenge_phrase	CERTIFICATE CHALLENGE PHRASE
* cert_type		CERTIFICATE TYPE (EXAMPLE: Server)
* server_type		SERVER TYPE (EXAMPLE: Apache)
* validity_period	LENGTH (IN YEARS) CERTIFICATE VALID FOR (1, 2, or 3 only)
* first_name		FIRST NAME OF REQUESTOR
* last_name		LAST NAME OF REQUESTOR
* email			EMAIL ADDRESS OF REQUESTOR. SHOULD BE THE TEAM EMAIL ADDR

### The output of a successful play is the cert, csr, and cert files being created.

### To run directly via commandline:
`ansible-playbook -i hosts_emcalvin_ssl_cert_example roles/ssl-cert-verisign/tasks/main.yml --extra-vars "key_file=/tmp/www.cscdev.com.key csr_file=/tmp/www.cscdev.com.csr cert_file=/tmp/www.cscdev.com.crt fqdn=www.cscdev.com ou=EIT challenge_phrase=DuckvillePlatapuss cert_type=Server server_type=Apache validity_period=1 first_name=Eric last_name=McAlvin email=emcalvin@cablevision.com"`
OR in a larger playbook:
`ansible-playbook -i hosts_emcalvin_ssl_cert_example ssl.yml --extra-vars "key_file=/tmp/www15.cscdev.com.key csr_file=/tmp/www15.cscdev.com.csr cert_file=/tmp/www15.cscdev.com.crt fqdn=www15.cscdev.com ou=EIT challenge_phrase=DuckvillePlatapuss cert_type=Server server_type=Apache validity_period=1 first_name=Eric last_name=McAlvin email=emcalvin@cablevision.com" -vvv`

### The inventory file in the above example uses the localhost to run the playbook and looks like this:
```
[local]
127.0.0.1
```
