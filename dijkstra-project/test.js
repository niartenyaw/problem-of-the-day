function* myPrimes() {
  val = 2
  while (true) {
    if (isPrime(val)) {
      yield val
    }
      val += 1
    console.log(val)
  }
}

function isPrime(val) {
  for (var idx =2 ; idx < val; idx++) {
    if ((val % idx) == 0) return false
  }
  return true
}
console.log(isPrime(2)
)

myPrimes().iter()
