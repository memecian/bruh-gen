#!/bin/bash

# Flag list:
# -h : Help
# -i : Interactive mode
# -u : do not sign the certificate with GPG key
# -o : output file name (default: $RECIPIENT-$TIME_OF_CERTIFICATION.txt)
# ---
# Non-interactive mode:
# -r : Recipient of the certificate
# -t : Time of the bruh moment
# -s : Bruh severity (1: bruh moment/2: bruh cascade/3: epic bruh moment)
# -c : Bruh moment reason
# -n : Certifier's name

while getopts "hiur:t:s:c:n:o:" opt; do
    case $opt in
        h)
            echo "Usage: bruhgen.sh [-i] [-u] [-r RECIPIENT] [-t TIME] [-s SEVERITY] [-c REASON] [-n CERTIFIER] [-o OUTPUT_FILE]"
            exit 0
            ;;
        i)
            INTERACTIVE="true"
            interactive_inputs
            ;;
        u)
            UNSIGNED="true"
            ;;
        r)
            RECIPIENT=$OPTARG
            ;;
        t)
            BRUH_TIME=$OPTARG
            ;;
        s)
            BRUH_SEVERITY=$OPTARG
            ;;
        c)
            BRUH_REASON=$OPTARG
            ;;
        n)
            BRUH_CERTIFIER=$OPTARG
            ;;
        o)
            OUTPUT_FILE=$OPTARG
            ;;
        \?)
            echo "Invalid option: $OPTARG" 1>&2
            exit 1
            ;;
    esac
done

# Interactive mode
interactive_inputs() {
    read -p "Recipient of the certificate: " RECIPIENT
    read -p "Time of the bruh moment (e.g., 2025-01-18T14:00:00Z): " BRUH_TIME
    read -p "Bruh severity (1: bruh moment/2: bruh cascade/3: epic bruh moment): " BRUH_SEVERITY
    read -p "Bruh moment reason: " BRUH_REASON
    read -p "Enter your name (certifier's name): " BRUH_CERTIFIER
}

TIME_OF_CERTIFICATION=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
OUTPUT_FILE="${RECIPIENT}-${TIME_OF_CERTIFICATION}.txt"

# Generate the certificate message
{
    figlet -f mini "CERTIFICATE OF BRUH"
    echo
    echo "TO WHOM IT MAY CONCERN,"
    echo
    echo "$RECIPIENT has caused, triggered, or experienced:"
    case $BRUH_SEVERITY in
	2)
        echo "  a certified cascade of bruh moments,"
		;;
	3)
        echo "  a bruh moment of epic proportions,"
        ;;
	*)
        echo "  a certified bruh moment,"
		;;
    esac
    echo
    echo "At the following time: $BRUH_TIME."
    echo
    echo "This was caused by the following: $BRUH_REASON."
    echo
    echo "Let it be known that this event has been reviewed and certified as a bruh moment of notable significance."
    echo
    echo "Bruh."
    echo
    echo "Certified on: $TIME_OF_CERTIFICATION"
    echo "Certified by: $BRUH_CERTIFIER"
} > "$OUTPUT_FILE"

if [[ $UNSIGNED != "true" ]]; then
    if [[ $INTERACTIVE == "true" ]]; then
        read -p "Do you want to sign the certificate with your GPG key? (yes/no): " SIGN_CHOICE
    fi
    if [[ $SIGN_CHOICE == "yes" ]]; then
        gpg --armor --detach-sign --output "$OUTPUT_FILE.asc" "$OUTPUT_FILE"
        echo >> "$OUTPUT_FILE"
        cat "$OUTPUT_FILE.asc" >> "$OUTPUT_FILE"
        rm "$OUTPUT_FILE.asc"
        echo "Certificate generated and signed: $OUTPUT_FILE"
    else
        echo "Certificate generated without signature: $OUTPUT_FILE"
    fi
else
    echo "Certificate generated without signature: $OUTPUT_FILE"
    exit 0
fi


