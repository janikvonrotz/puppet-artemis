# Artemis Puppet Module

Local deployable Puppet module that configures an Artemis broker instance.

## Reference

Checkout the generated [reference document](/REFERENCE.md) of the `puppet::artemis` class.

# Local Deployment

## Requirements

The following requirements apply to a local deployment:

* The deployment user must be able to do a **passwordless sudo** on localhost
* The installed **puppet cli** must be at least version **5.0**
* Artemis Puppet module has the following dependencies:
  * [stdlib](https://forge.puppet.com/puppetlabs/stdlib)
* Build dependencies:
  * [puppet-lint](http://puppet-lint.com/)
  * [puppet strings](https://puppet.com/docs/puppet/latest/puppet_strings.html)

## Gradle Properties

**PUPPET_HIERA_CONFIG**  
`default: template/hiera.yaml`  
Path to the Puppet hiera.yaml configuration file.

**PUPPET_NODE_CONFIG**  
`default: template/site.pp`  
Path to the Puppet node configuration file.

**PUPPET_ENV**  
`default: dev`  
Hiera data environment name.

## Gradle Tasks

**puppetPrepare**  
Copy key material.

**puppetApply**  
Install Artemis broker with Puppet.

**puppetClean**  
Remove Artemis broker instance with Puppet.

**moduleZip**  
Create Artemis Puppet module zip file.

**puppetLint**  
Run Puppet Lint.

**puppetStrings**  
Run Puppet Strings and generate reference doc.

# Development

## Integration

If you want to use the Artemis module in another project, follow these steps:

* Copy everything from the **template folder** to the target project
* Rename the `data/dev` folder to the target environment name
* Publish and pull the **puppet-artemis.zip** from a repository
* **Unzip** the Artifcat to a Puppet modules folder
* **Install** the Artemis Puppet module **dependencies**
* Run `FACTER_env=$ENVIRONMENT_NAME puppet apply --modulepath $MODULES_PATH  $NODE_CONFIG_PATH --hiera_config=$HIERA_CONFIG_PATH` to deploy an Artemis instance