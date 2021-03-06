package SBEAMS::ProteinStructure::Settings;

###############################################################################
# Program     : SBEAMS::ProteinStructure::Settings
# Author      : Eric Deutsch <edeutsch@systemsbiology.org>
# $Id$
#
# Description : This is part of the SBEAMS::ProteinStructure module which handles
#               setting location-dependant variables.
#
###############################################################################


use strict;

#### Begin with the main Settings.pm
use SBEAMS::Connection::Settings;


#### Set up new variables
use vars qw(@ISA @EXPORT 
    $SBEAMS_PART
);

require Exporter;
@ISA = qw (Exporter);

@EXPORT = qw (
    $SBEAMS_PART
);


#### Define new variables
$SBEAMS_PART            = 'ProteinStructure';


#### Override variables from main Settings.pm
$SBEAMS_SUBDIR          = 'ProteinStructure';
