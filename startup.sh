#!/bin/bash -eux

sed -i "s/##HOSTNAME##/${HOSTNAME}/" /etc/default/spampd

