# Author: Siddhant Evre

from fastapi import FastAPI
from fastapi import Request
from fastapi.responses import JSONResponse
import db_helper
import generic_helper

app = FastAPI()

inprogress_claims = {}

@app.post("/")
async def handle_request(request: Request):
    # Retrieve the JSON data from the request
    payload = await request.json()

    # Extract the necessary information from the payload
    # based on the structure of the WebhookRequest from Dialogflow
    intent = payload['queryResult']['intent']['displayName']
    parameters = payload['queryResult']['parameters']
    output_contexts = payload['queryResult']['outputContexts']
    session_id = generic_helper.extract_session_id(output_contexts[0]["name"])

    intent_handler_dict = {
        'file.claim': file_claim,
        'claim.status': check_claim_status,
        'new.policy': check_policy_details,
        'payment.inquiry': check_payment_status,
        'contact.agent': contact_agent
    }

    return intent_handler_dict[intent](parameters, session_id)

def save_claim_to_db(claim: dict):
    next_claim_id = db_helper.get_next_claim_id()

    # Insert claim details into the database
    rcode = db_helper.insert_claim_details(
        claim['incident'],
        claim['policy_number'],
        next_claim_id
    )

    if rcode == -1:
        return -1

    # Now insert claim tracking status
    db_helper.insert_claim_tracking(next_claim_id, "in progress")

    return next_claim_id

def file_claim(parameters: dict, session_id: str):
    incident = parameters["incident"]
    policy_number = parameters["policy_number"]

    if session_id not in inprogress_claims:
        inprogress_claims[session_id] = {"incident": incident, "policy_number": policy_number}
        fulfillment_text = "I have recorded your incident details. Do you want to proceed with filing the claim?"
    else:
        claim = inprogress_claims[session_id]
        claim_id = save_claim_to_db(claim)
        if claim_id == -1:
            fulfillment_text = "Sorry, I couldn't process your claim due to a backend error. Please try again later."
        else:
            fulfillment_text = f"Your claim has been filed successfully. Here is your claim id # {claim_id}. We will notify you about the status of your claim soon."

        del inprogress_claims[session_id]

    return JSONResponse(content={
        "fulfillmentText": fulfillment_text
    })

def check_claim_status(parameters: dict, session_id: str):
    claim_id = int(parameters['claim_id'])
    claim_status = db_helper.get_claim_status(claim_id)
    if claim_status:
        fulfillment_text = f"The status of your claim id {claim_id} is: {claim_status}"
    else:
        fulfillment_text = f"No claim found with claim id: {claim_id}"

    return JSONResponse(content={
        "fulfillmentText": fulfillment_text
    })

def check_policy_details(parameters: dict, session_id: str):
    policy_number = parameters["policy_number"]
    policy_details = db_helper.get_policy_details(policy_number)
    if policy_details:
        fulfillment_text = f"Here are your policy details: {policy_details}"
    else:
        fulfillment_text = f"No policy found with policy number: {policy_number}"

    return JSONResponse(content={
        "fulfillmentText": fulfillment_text
    })

def check_payment_status(parameters: dict, session_id: str):
    policy_number = parameters["policy_number"]
    payment_status = db_helper.get_payment_status(policy_number)
    if payment_status:
        fulfillment_text = f"Your payment status for policy number {policy_number} is: {payment_status}"
    else:
        fulfillment_text = f"No payment details found for policy number: {policy_number}"

    return JSONResponse(content={
        "fulfillmentText": fulfillment_text
    })

def contact_agent(parameters: dict, session_id: str):
    # Simulate the process of connecting to an agent
    fulfillment_text = "Connecting you to an agent. Please hold..."
    return JSONResponse(content={
        "fulfillmentText": fulfillment_text
    })
