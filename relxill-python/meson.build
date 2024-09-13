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

add_project_arguments(
    cxx.get_supported_arguments(
        '-fPIC',
        '-flto=auto',
        '-ffunction-sections',
        '-fdata-sections',
    ),
    language: 'cpp',
)

add_project_link_arguments(
    cxx.get_supported_link_arguments(
        '-flto=auto',
        '-Wl,--gc-sections',
    ),
    language: 'cpp',
)

relxill = declare_dependency(
    dependencies: [
        cxx.find_library('Relxill'),
        dependency('cfitsio'),
        dependency('fftw3'),
    ],
)

python = import('python').find_installation(pure: false)

python.extension_module(
    'relxill',
    'relxill.pyx',
    dependencies: [
        relxill,
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
    link_args: [
        cxx.get_supported_link_arguments('-Wl,-noimplib'),
    ],
    install: true,
    limited_api: '3.7',
)
