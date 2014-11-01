#!/usr/bin/env rake

task :ci => [:dump, :test]

task :dump do
    sh 'vim --version'
end

task :test do
    sh <<'...'
if ! [ -d .deps/ ]; then
    mkdir .deps/
    git clone https://github.com/thinca/vim-themis .deps/themis/
    git clone https://github.com/vim-jp/vital.vim .deps/vital/
fi
...
    sh '.deps/themis/bin/themis --runtimepath .deps/vital/ --recursive'
end
