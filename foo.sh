while IFS== read -r key val ; do
    val=${val%\"}; val=${val#\"}; key=${key#export };
    echo "$key = $val";
  done < IF_data.txt