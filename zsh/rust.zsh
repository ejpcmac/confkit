##########################
# Rust (Setup & Aliases) #
##########################

##
## Setup
##

export PATH=$PATH:$HOME/.cargo/bin

##
## Aliases
##

# Setup
alias rget='curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path'
alias cia='cargo install \
    cargo-update \
    cargo-generate \
    cargo-outdated \
    cargo-crev \
    cargo-binutils \
    cargo-testify \
    cargo-watch'

# Rustup
alias ru='rustup update'
alias rtl='rustup toolchain list'
alias rti='rustup toolchain install'
alias rtu='rustup toolchain uninstall'
alias rtal='rustup target list'
alias rtaa='rustup target add'
alias rtar='rustup target remove'
alias rde='rustup default'
alias rcl='rustup component list'
alias rca='rustup component add'
alias rcr='rustup component remove'

# Cargo
alias c='cargo'
alias ci='cargo install'
alias cif='cargo install --force'
alias ciu='cargo install-update --all'
alias cun='cargo uninstall'
alias co='cargo outdated'
alias ca='cargo audit'
alias cb='cargo build'
alias cbr='cargo build --release'
alias cbl='cargo build --release --target=x86_64-unknown-linux-musl'
alias ccp='cargo clippy'
alias cr='cargo run'
alias ct='cargo test'
alias cs='cargo size --bin'
alias csr='cargo size --release --bin'
alias ctw='cargo testify -- --color always'
alias ccl='cargo clean'
alias cdoc='cargo doc'
alias cdo='cargo doc --open'
