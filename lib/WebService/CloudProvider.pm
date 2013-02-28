package WebService::CloudProvider;

use 5.010;
use Any::Moose;
with 'Web::API';

=head1 NAME

WebService::CloudProvider - an interface to cloudprovider.net's RESTful Web API using Web::API

=head1 VERSION

Version 0.2.2

=cut

our $VERSION = '0.2';

has 'commands' => (
    is      => 'rw',
    default => sub {
        {
            list_nodes => { method => 'GET' },
            node_info  => { method => 'GET', require_id => 1 },
            create_node => {
                method             => 'POST',
                default_attributes => {
                    allowed_hot_migrate            => 1,
                    required_virtual_machine_build => 1,
                    cpu_shares                     => 5,
                    required_ip_address_assignment => 1,
                    primary_network_id             => 1,
                    required_automatic_backup      => 0,
                    swap_disk_size                 => 1,
                },
                mandatory => [
                    'label',
                    'hostname',
                    'template_id',
                    'cpus',
                    'memory',
                    'primary_disk_size',
                    'required_virtual_machine_build',
                    'cpu_shares',
                    'primary_network_id',
                    'required_ip_address_assignment',
                    'required_automatic_backup',
                    'swap_disk_size',
                ]
            },
            update_node => { method => 'PUT',    require_id => 1 },
            delete_node => { method => 'DELETE', require_id => 1 },
            start_node  => {
                method       => 'POST',
                require_id   => 1,
                post_id_path => 'startup',
            },
            stop_node => {
                method       => 'POST',
                require_id   => 1,
                post_id_path => 'shutdown',
            },
            suspend_node => {
                method       => 'POST',
                require_id   => 1,
                post_id_path => 'suspend',
            },
        };
    },
);

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use WebService::CloudProvider;

    my $foo = WebService::CloudProvider->new();
    ...

=head1 SUBROUTINES/METHODS

=head2 list_nodes

=head2 node_info

=head2 create_node

=head2 update_node

=head2 delete_node

=head2 start_node

=head2 stop_node

=head2 suspend_node

=head1 INTERNALS

=cut

sub commands {
    my ($self) = @_;
    return $self->commands;
}

=head2 BUILD

basic configuration for the client API happens usually in the BUILD method when using Web::API

=cut

sub BUILD {
    my ($self) = @_;

    $self->user_agent(__PACKAGE__ . ' ' . $VERSION);
    $self->base_url('https://ams01.cloudprovider.net/virtual_machines');
    $self->auth_type('basic');
    $self->content_type('application/json');
    $self->extension('json');
    $self->wrapper('virtual_machine');
    $self->mapping({
            os        => 'template_id',
            debian    => 1,
            id        => 'label',
            disk_size => 'primary_disk_size',
    });

    return $self;
}

=head1 AUTHOR

Tobias Kirschstein, C<< <lev at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-webservice-cloudprovider at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-CloudProvider>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WebService::CloudProvider

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebService-CloudProvider>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WebService-CloudProvider>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WebService-CloudProvider>

=item * Search CPAN

L<http://search.cpan.org/dist/WebService-CloudProvider/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Tobias Kirschstein.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1;    # End of WebService::CloudProvider
