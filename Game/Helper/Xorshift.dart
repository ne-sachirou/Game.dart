// Dart: Structured web apps [8] random | hiro345 http://www.sssg.org/blogs/hiro345/archives/9616.html
class Xorshift {
  static num x = 123456789;
  static num y = 362436069;
  static num z = 521288629;
  static num w = 88675123;
  int min = 0;
  int max = 1;
  
  Xorshift();
  
  Xorshift.minmax(this.min, this.max);
  
  void seed(num x0, num y0, num z0, num w0) {
    x = x0;
    y = y0;
    z = z0;
    w = w0;
    if (x + y + z + w <= 0) {
      x = 123456789;
      y = 362436069;
      z = 521288629;
      w = 88675123; 
    }
  }
  
  num xor128() { 
    num t = x ^ (x << 11);
    x = y;
    y = z;
    z = w;
    w = (w ^ (w >> 19)) ^ (t ^ (t >> 8));
    return w; 
  }
  
  int random() {
    num r = xor128();
    return (min + r) % max + min;
  }
}