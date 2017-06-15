# HOW TO USE THIS ROLE:

### This role expects the following variables to be set:
* fqdn		THIS IS THE WEBSITE FQDN. EXAMPLE: mywebapp.cablevision.com
* cert_length_years	THIS IS THE LENGTH (IN YEARS) OF THE SSL CERTIFICATE. TYPICALLY 1

### The output of a successful play is the filename of the SSL certificate PEM file (key + cert).  It gets stored in the variable: ssl_cert_pem_filename

### To run directly via commandline:
`ansible-playbook -i hosts_emcalvin_ssl_cert_example roles/ssl-cert-selfsigned/tasks/main.yml --extra-vars "fqdn=cvldarch01-11v.cscdev.com cert_length_years=2"`

### The inventory file in the above example uses the localhost to run the playbook and looks like this:
```
[local]
127.0.0.1
```
