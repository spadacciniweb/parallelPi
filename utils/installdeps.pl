use Module::Build;

my $build = Module::Build->new(
    module_name     => 'parallelPi',
    dist_version    => '0.1',
    requires        => {qw(
        Config::Tiny 0
        DateTime 0
        TryCatch 0
    )},
);
$build->dispatch('installdeps');
