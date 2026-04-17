pkgname=bfm-bash
pkgver=0.2.0
pkgrel=1
pkgdesc="Minimal TUI file manager written in Bash"
arch=('any')
url="https://github.com/Hugo1974/bfm"
license=('GPL2')
depends=('bash' 'coreutils' 'ncurses')
source=("git+https://github.com/Hugo1974/bfm.git")
sha256sums=('SKIP')

package() {
  cd "$srcdir/bfm"

  install -Dm755 main.sh "$pkgdir/usr/bin/bfm"

  install -Dm644 README.md "$pkgdir/usr/share/doc/bfm/README.md"
  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/bfm/LICENSE"
}
