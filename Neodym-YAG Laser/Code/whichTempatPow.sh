a=-0.0261943
b=35.4583

result=$(echo "$a * $1 + $b" | bc)

echo "At a power of $1 mW use a temperature of $result °C"