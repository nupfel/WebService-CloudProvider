package WebService::CloudProvider;

use 5.010;
use Mouse;

# ABSTRACT: WebService::CloudProvider - an interface to cloudprovider.net's RESTful Web API using Web::API

# VERSION

with 'Web::API';

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

=cut

has 'commands' => (
    is      => 'rw',
    default => sub {
        {
            list_nodes  => { method => 'GET', path => 'virtual_machines' },
            node_info   => { method => 'GET', path => 'virtual_machines/:id' },
            create_node => {
                path               => 'virtual_machines',
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
            update_node => {
                method => 'PUT',
                path   => 'virtual_machines/:id',
            },
            delete_node => {
                method => 'DELETE',
                path   => 'virtual_machines/:id',
            },
            start_node => {
                method => 'POST',
                path   => 'virtual_machines/:id/startup',
            },
            stop_node => {
                method => 'POST',
                path   => 'virtual_machines/:id/shutdown',
            },
            suspend_node => {
                method => 'POST',
                path   => 'virtual_machines/:id/suspend',
            },
        };
    },
);

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
    $self->base_url('https://ams01.cloudprovider.net/');
    $self->auth_type('basic');
    $self->content_type('application/json');

    # $self->extension('json');
    $self->wrapper('virtual_machine');
    $self->mapping({
        os        => 'template_id',
        debian    => 1,
        id        => 'label',
        disk_size => 'primary_disk_size',
    });

    return $self;
}

=head1 BUGS

Please report any bugs or feature requests on GitHub's issue tracker L<https://github.com/nupfel/WebService-CloudProvider/issues>.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WebService::CloudProvider


You can also look for information at:

=over 4

=item * GitHub repository

L<https://github.com/nupfel/WebService-CloudProvider>

=item * MetaCPAN

L<https://metacpan.org/module/WebService::CloudProvider>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WebService::CloudProvider>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WebService::CloudProvider>

=back

=cut

1;    # End of WebService::CloudProvider
