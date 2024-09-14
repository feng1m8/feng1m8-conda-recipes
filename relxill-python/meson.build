project(
    'relxill-python', 'cpp', 'cython',
    version: '2.3.1',
    license: 'MIT',
    default_options: {
        'b_ndebug': 'if-release',
        'buildtype': 'release',
        'cpp_std': 'c++17',
    },
)

cxx = meson.get_compiler('cpp')

add_project_link_arguments(
    cxx.get_supported_link_arguments(
        '-Wl,-noimplib',
    ),
    language: 'cpp',
)

python = import('python').find_installation(pure: false)

python.extension_module(
    'relxill',
    'relxill.pyx',
    dependencies: [
        cxx.find_library('Relxill'),
        dependency('cfitsio'),
        dependency('fftw3'),
    ],
    cpp_args: [
        '-DCYTHON_LIMITED_API',
    ],
    override_options: [
        'cython_language=cpp',
    ],
    cython_args:[
        '--module-name=relxill',
    ],
    install: true,
    limited_api: '3.7',
)
