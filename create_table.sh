gcloud cloud-shell scp localhost:./tootback_db/schema_toots_load.json localhost:./tootback_db/schema_toots_bigram.json cloudshell:~/

# 以下はSSH内で実行
bq rm --table --force tootback:tbds.toots_load
bq rm --table --force tootback:tbds.toots_bigram

bq mk \
--table \
--description="バッチからのトゥートの読み込み先" \
--time_partitioning_type=HOUR \
--time_partitioning_field=created_at \
--time_partitioning_expiration=3600 \
--require_partition_filter=true \
tbds.toots_load ./schema_toots_load.json

bq mk \
--table \
--description="トゥートのbi-gram" \
--time_partitioning_type=HOUR \
--time_partitioning_field=created_at \
--time_partitioning_expiration=86400 \
--require_partition_filter=true \
tbds.toots_bigram ./schema_toots_bigram.json

rm schema_toots*.json
exit