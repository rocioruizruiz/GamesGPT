#lanzar con streamlit run c_front_end.py en el terminal

import QR_backend
import streamlit as st
from streamlit_chat import message


def run_app():

    st.title("EYOF Medal Standing")
    st.write("Ask anything about EYOF medal standing from 1991 to 2023.")


    ### NEW!!! Borrar esto si se quiere volver a lo anterior, y poner lo que hay en el archivo old.py
    if "messages" not in st.session_state:
        st.session_state.messages = []

    # Display chat messages from history on app rerun
    for message in st.session_state.messages:
        with st.chat_message(message["role"]):
            st.markdown(message["content"])

    # Accept user input
    if query := st.chat_input("Ask your questions?"):
        st.session_state.messages.append({"role": "user", "content": query})
        print(st.session_state.messages)
        with st.chat_message("user"):
            st.markdown(query)

        # Query the assistant using the latest chat history
        result = QR_backend.consulta({"query": query, "chat_history": [(message["role"], message["content"]) for message in st.session_state.messages]})
        #print(result)

        # Display assistant response in chat message container
        with st.chat_message("assistant"):
            message_placeholder = st.empty()
            full_response = ""
            full_response = result #["result"]
            message_placeholder.markdown(full_response + "|")
        message_placeholder.markdown(full_response)    
        print(full_response)
        st.session_state.messages.append({"role": "assistant", "content": full_response})


if __name__ == "__main__":

    run_app()