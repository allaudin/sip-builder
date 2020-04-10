## Pjsip Builder

Bash scripts for generating pjsip binaries for android.

### Steps

1. Create a separate direcotry
2. Clone all the scripts to newly created directory
3. Add necessary config directives in `config.h` file
4. Run `start.sh`
5. Collect binaries from `output` directory or send files to `Android Project` using following command


`./copy.sh path-to-android-project-root-dir`

### Versions

ndk: r16b
pjsip: 2.9
openssl: 1.1.1c

### ToDo

Compile with video module

Made with :heart: by Allaudin


