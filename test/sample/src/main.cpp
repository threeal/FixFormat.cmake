#include <cassert>
#include <sample.hpp>

int main() {
  assert(is_odd(3));
  assert(fibonacci_sequence(3).size() == 3);
  return 0;
}
