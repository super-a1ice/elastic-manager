#!/bin/bash
INDEX=""
ES_URL="http://elasticsearch:9200"
function print_usage() {
    echo "Usage: $0 [-l host] [-i index]" 1>&2
    exit 1
}
DRY_RUN=0
while [ "$1" != "" ]; do
    case $1 in
        -l | -host )
            ES_URL=$2
            if [ "$ES_URL" = "" ]; then
                echo "Error: Missing Elasticsearch URL"
                print_usage
                exit 1
            fi
            ;;

        -h | -help )
            print_usage
            exit 0
            ;;

         *)
            echo "Error: Unknown option $2"
            print_usage
            exit 1
            ;;
    esac
    shift 2
done
for index in $(curl -s -q ${ES_URL}/_cat/indices |awk '{ print $3 }')
do
	echo "elasticdump --limit=10000 --input=\"${ES_URL}/${index}*\" --output=$ | gzip > ${index}.json.gz"
done

# ./backup-index.sh |bash
