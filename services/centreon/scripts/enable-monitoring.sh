#!/bin/bash

# Start/restart collect processes
systemctl restart cbd centengine 2>/dev/null

# Restart the tasks manager
systemctl restart gorgoned 2>/dev/null

# Start the passive monitoring services
systemctl start snmptrapd centreontrapd 2>/dev/null

# Start the SNMP daemon
systemctl start snmpd 2>/dev/null

