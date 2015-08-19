class gatling($version) {

    package { 'unzip':
        ensure => installed,
    }

    package { 'wget':
        ensure => installed,
    }

    package { 'screen':
        ensure => installed,
    }

    package { 'default-jre':
        ensure => installed,
    }

    exec { 'download-gatling':
        command => "wget https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/$version/gatling-charts-highcharts-bundle-$version-bundle.zip",
        path => '/usr/bin:/bin:/usr/sbin:/usr/local/bin',
        cwd => '/tmp',
        user => 'root',
        creates => "/tmp/gatling-charts-highcharts-bundle-$version-bundle.zip",
        onlyif => "test ! -f /opt/gatling",
        require => Package['wget'],
    }

    exec { 'unzip-gatling':
        command => "unzip gatling-charts-highcharts-bundle-$version-bundle.zip",
        path => '/usr/bin:/bin:/usr/sbin:/usr/local/bin',
        cwd => '/tmp',
        user => 'root',
        require => [
            Exec['download-gatling'],
            Package['unzip'],
        ]
    }

    exec { 'cleanup-gatling':
        command => "rm gatling-charts-highcharts-bundle-$version-bundle.zip",
        path => '/usr/bin:/bin:/usr/sbin:/usr/local/bin',
        cwd => '/tmp',
        user => 'root',
        require => Exec['unzip-gatling']
    }

    exec { 'install-gatling':
        command => "mv /tmp/gatling-charts-highcharts-bundle-$version /opt/gatling",
        path => '/usr/bin:/bin:/usr/sbin:/usr/local/bin',
        creates => '/opt/gatling',
        require => Exec['unzip-gatling']
    }
}
