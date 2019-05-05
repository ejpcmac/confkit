########################################
# Aliases and functions for developers #
########################################

##
## Aliases
##

# Certificate creation
alias devcert='generate-ca-and-server --auto ca server 2048'

# PostgreSQL (for use with Nix)
alias pgst='pg_ctl -o "-k $PGDATA" -l "$PGDATA/server.log" start'
alias pgsp='pg_ctl stop'
alias pgswitch='killall postgres && pgst'

# MongoDB (for use with Nix)
alias mongost='mongod --config mongod.conf --fork'
alias mongosp='mongo admin --eval "db.shutdownServer()"'

##
## Functions
##

## VSCode

code-nofmt() {
    mkdir -p .vscode
    cat > .vscode/settings.json << 'EOF'
{
    "editor.formatOnPaste": false,
    "editor.formatOnSave": false,
    "editor.formatOnType": false
}
EOF
}

## Certificate creatiton

gencert() {
    if [[ $# -ne 2 ]]; then
        echo "usage: gencert <ca_file> <server_file>"
        return 1
    fi

    generate-ca-and-server --ca-encrypt $@ 4096
}

devcert-client() {
    if [[ $# -ne 1 ]]; then
        echo "usage: devcert-client <name>"
        return 1
    fi

    generate-certificate --name $1 ca $1 2048
}

###
## Generates self-signed CA and server certificates.
##
## Options:
##
##   * `--auto`: Use a default common name for both the CA and server.
##   * `-ca-encrypt`: Encrypt the CA private key using AES-256.
##
generate-ca-and-server() {
    for a in $@; do
        case $a in
            --auto)
                typeset subj=-subj
                typeset ca_subject="/CN=Local CA for development"
                typeset req_name=--name
                typeset server_name="localhost"
                shift
                ;;

            --ca-encrypt)
                typeset ca_encrypt=-aes256
                shift
                ;;
        esac
    done

    if [[ $# -ne 3 ]]; then
        echo "usage: generate-certificate [--auto] [--ca-encrypt] <ca_file> <server_file> <key_size>"
        return 1
    fi

    typeset ca=$1
    typeset server=$2
    typeset key_size=$3

    printf "\e[32m=> Generating the CA private key...\e[0m\n" &&
    openssl genrsa $ca_encrypt -out $ca.key $key_size &&
    echo &&

    printf "\e[32m=> Generating the CA certificate...\e[0m\n" &&
    openssl req -new -x509 -sha256 \
        $subj $ca_subject \
        -days 90 \
        -key $ca.key \
        -out $ca.crt &&
    echo &&

    printf "\e[32m=> Generating a certificate for the server...\e[0m\n" &&
    generate-certificate $req_name $server_name $ca $server $key_size
}

###
## Generates a certificate using a given Certification Authority.
##
## Options:
##
##   * `--encrypt`: Encrypt the private key using AES-256.
##   * `--name`: Set the certificate Common Name and avoid prompting the
##       request form.
##
generate-certificate() {
    for a in $@; do
        case $a in
            --encrypt)
                typeset encrypt=-aes256
                shift
                ;;

            --name)
                typeset subj=-subj
                typeset subject="/CN=$2"
                shift
                shift
                ;;
        esac
    done

    if [[ $# -ne 3 ]]; then
        echo "usage: generate-certificate [--encrypt] [--name <common_name>] <ca_name> <cert_name> <key_size>"
        return 1
    fi

    typeset ca=$1
    typeset name=$2
    typeset key_size=$3

    printf "\e[32m=> Generating the private key...\e[0m\n" &&
    openssl genrsa -out $name.key $key_size &&
    echo &&

    printf "\e[32m=> Generating a certificate request...\e[0m\n" &&
    openssl req -new \
        $subj $subject \
        -key $name.key \
        -out $name.csr &&
    echo &&

    printf "\e[32m=> Signing the certificate...\e[0m\n" &&
    openssl x509 -req -sha256 \
        -CA $ca.crt -CAkey $ca.key -CAcreateserial \
        -days 90 \
        -in $name.csr \
        -out $name.crt &&
    echo &&

    rm $name.csr &&
    rm $ca.srl &&

    printf "\e[32m\e[1mCertificate generation complete!\e[0m\n\n"
}
