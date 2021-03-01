"""
Tools for managing the EESSI infrastructure
:author: Terje Kvernes (University of Oslo)
"""

import os
import subprocess

NODE_TYPES = [ 'small', 'medium', 'large' ]
ARCHITECTURES = [ 'x86_64', 'aarch64', 'power', 'macos_catalina_x86_64', 'macos_catalina_aarch64', 'macos_big_sur_x86_64', 'macos_big_sur_aarch64' ]
DEFAULT_ARCHITECTURES = [ 'x86_64', 'aarch64' ]
TERRAFORM_COMMANDS = [ 'plan', 'apply', 'destroy' ]
TF_ENV_PREFIX = 'TF_VAR'
ROOT_DIRECTORY = os.path.dirname(os.path.realpath(__file__))
TERRAFORM_DIRECTORY = ROOT_DIRECTORY + "/../terraform"

def is_acceptable_terraform_command(command):
    """
    Checks to see if a given terraform command is valid
    """
    return command in TERRAFORM_COMMANDS

def is_acceptable_node_type(node_type):
    """
    Checks to see if a node type is familiar to the project.
    """
    return node_type in NODE_TYPES

def is_acceptable_architecture(arch):
    """
    Checks to see if an architecture is familiar to the project.
    """
    return arch in ARCHITECTURES

def execute(cmd,print_stdout=False):
    """
    Executes a command, prints stdout, raises error if it fails.
    """
    process = subprocess.Popen(cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        universal_newlines=True)

    return_code = process.wait()
    (stdout,stderr) = process.communicate()

    if print_stdout:
        print(stdout)
    if return_code:
        print(stderr)
        raise subprocess.CalledProcessError(return_code, cmd)

    return stdout

def ensure_terraform_is_initialized(directory='.terraform'):
    """
    Ensure that terraform is appropriately initialized.
    """
    os.chdir(TERRAFORM_DIRECTORY)

    if not os.path.isdir(directory):
        print("Initializing terraform.")
        output = execute(['terraform', 'init'], print_stdout=False)
#        print(output)

def destroy_infrastructure():
    """
    Runs terraform destroy.
    """
    # Mode is not relevant for destroy, but needs setting for TF.
    set_terraform_env('mode', 'large')
    os.chdir(TERRAFORM_DIRECTORY)
    execute(['terraform', 'destroy', '-auto-approve'])

def set_terraform_env(key, value):
    """
    Sets a prefixed TF_ENV-variable to the given value.
    """
    os.environ["{}_{}".format(TF_ENV_PREFIX, key)] = value
