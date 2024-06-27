import mysql.connector
global cnx

cnx = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",
    database="insurance_db"
)

def get_policy_details(policy_number):
    cursor = cnx.cursor()
    query = f"SELECT details FROM policies WHERE policy_number = '{policy_number}'"
    cursor.execute(query)
    result = cursor.fetchone()
    cursor.close()
    return result[0] if result else "No details found for this policy number."

def get_claim_status(claim_number):
    cursor = cnx.cursor()
    query = f"SELECT status FROM claims WHERE claim_number = '{claim_number}'"
    cursor.execute(query)
    result = cursor.fetchone()
    cursor.close()
    return result[0] if result else "No status found for this claim number."

def get_faq_response(faq_topic):
    cursor = cnx.cursor()
    query = f"SELECT response FROM faqs WHERE topic = '{faq_topic}'"
    cursor.execute(query)
    result = cursor.fetchone()
    cursor.close()
    return result[0] if result else "No information available for this topic."
