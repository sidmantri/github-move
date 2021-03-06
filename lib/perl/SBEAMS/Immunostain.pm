package SBEAMS::Immunostain;

###############################################################################
# Program     : SBEAMS::Immunostain
# Author      : Eric Deutsch <edeutsch@systemsbiology.org>
# $$
#
# Description : Perl Module to handle all SBEAMS - Immunostain specific items.
#
###############################################################################


use strict;
use vars qw($VERSION @ISA $sbeams);
use CGI::Carp qw( croak);

use SBEAMS::Immunostain::DBInterface;
use SBEAMS::Immunostain::HTMLPrinter;
use SBEAMS::Immunostain::TableInfo;
use SBEAMS::Immunostain::Tables;
use SBEAMS::Immunostain::Settings;
use SBEAMS::Connection::Settings;

use SBEAMS::Connection::Log;

@ISA = qw(SBEAMS::Immunostain::DBInterface
          SBEAMS::Immunostain::HTMLPrinter
          SBEAMS::Immunostain::TableInfo
          SBEAMS::Immunostain::Settings);


###############################################################################
# Global Variables
###############################################################################
$VERSION = '0.02';
my $log = SBEAMS::Connection::Log->new();


###############################################################################
# Constructor
###############################################################################
sub new {
    my $this = shift;
    my $class = ref($this) || $this;
    my $self = {};
    bless $self, $class;
    return($self);
}


###############################################################################
# Receive the main SBEAMS object
###############################################################################
sub setSBEAMS {
    my $self = shift;
    $sbeams = shift;
    return($sbeams);
}


###############################################################################
# Provide the main SBEAMS object
###############################################################################
sub getSBEAMS {
    my $self = shift;
    return($sbeams);
}

sub getProjectData {
  my $self = shift;
  my %args = @_;
  my %project_data;
  $log->debug( join '::', keys( %args ) );

  unless ( scalar(@{$args{projects}}) ) {
    $log->warn( 'No project list provided to getProjectData' );
    return ( \%project_data);
  }
 
  my $projects = join ',', @{$args{projects}};

  # Query to find data in this module (by project).
  my $sql =<<"  END_SQL";
  SELECT COUNT(ss.assay_id) Assays, COUNT(DISTINCT sp.specimen_id) Specimens,
         sp.project_id
	FROM $TBIS_ASSAY ss
	RIGHT OUTER JOIN $TBIS_SPECIMEN_BLOCK sb 
       ON ss.specimen_block_id = sb.specimen_block_id
	RIGHT OUTER JOIN $TBIS_SPECIMEN sp 
       ON sb.specimen_id = sp.specimen_id
	WHERE sp.project_id IN ( $projects )
  AND sp.record_status != 'D'
  AND ( sb.record_status != 'D' OR sb.record_status IS NULL )
  AND ( ss.record_status != 'D' OR ss.record_status IS NULL )
  GROUP BY sp.project_id
  END_SQL

#  my $mod_button = $self->getSBEAMS()->getModuleButton( 'Immunostain' );
  my $cgi_dir = $CGI_BASE_DIR . '/Immunostain/';
  my @rows = $self->getSBEAMS()->selectSeveralColumns( $sql );
  foreach my $row ( @rows ) {
    $project_data{$row->[2]} =<<"    END_LINK";
    <A HREF=${cgi_dir}main.cgi?set_current_project_id=$row->[2]>
     <DIV id=Immunostain_button TITLE='$row->[0] Assays from $row->[1] Specimens'>
     Immunostain
     </DIV>
    </A>
    END_LINK
  }
  return ( \%project_data );
}

###############################################################################

1;

__END__
###############################################################################
###############################################################################
###############################################################################
