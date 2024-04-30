#import a_env_vars
import os

#from langchain.sql_database import SQLDatabase
from langchain_community.utilities import SQLDatabase
from langchain_openai import ChatOpenAI
from langchain.chains import create_sql_query_chain
from dotenv import load_dotenv, find_dotenv


# 1. Cargar la bbdd con langchain
#db = SQLDatabase.from_uri("sqlite:///Users/eruiz/Desktop/Workspace/ChainSQL/ecommerce.db")
db = SQLDatabase.from_uri("mysql+pymysql://root:Zaragoza.24@localhost/SphereDB")

# 2. Importar las APIs
#os.environ["OPENAI_API_KEY"] = os.environ.get("OPENAI_API_KEY")
load_dotenv(find_dotenv(), override=True)

# 3. Crear el LLM
llm = ChatOpenAI(temperature=0,model_name='gpt-3.5-turbo')

# 4. Crear la cadena
#cadena = create_sql_query_chain(llm, db)

# 5. Formato personalizado de respuesta
formato = """
Eres un asistente de IA muy inteligente, experto en identificar preguntas relevantes del usuario y convertirlas en consultas sql para generar la respuesta correcta. 
Ademas eres un experto en MySQL. Dada una pregunta de entrada, primero crea una consulta MySQL sintácticamente correcta para ejecutarla, luego mira los resultados de la consulta y devuelve la respuesta a la pregunta de entrada.
A menos que el usuario especifique en la pregunta un número concreto de ejemplos a obtener, consulta como máximo 5 resultados utilizando la cláusula LIMIT según MySQL. 
Puedes ordenar los resultados para obtener los datos más informativos de la base de datos.
Nunca consultes todas las columnas de una tabla. 
Sólo debe consultar las columnas necesarias para responder a la pregunta. 
Escriba el nombre de cada columna entre comillas dobles (") para indicar que se trata de identificadores delimitados.
Ten cuidado de no consultar columnas que no existen. Además, presta atención a qué columna está en qué tabla.
Preste atención a utilizar la función date('now') para obtener la fecha actual, si la pregunta implica "hoy".
Presta atención a utilizar sólo los nombres de columna que puede ver en las tablas siguientes. 
Como experto, debe utilizar joins siempre que sea necesario.

Usa el siguiente formato:

Question: Question here
SQLQuery: SQL Query to run
SQLResult: Result of the SQLQuery
Answer: Final answer here

Debes consultar contra la base de datos conectada, tiene un total de 6 tablas, estas son: Customer, CustomerOrder, OrderItem, Product, Supplier, GamesMedals.
Para responder las preguntas solo necesitas atender a la tabla GamesMedals
Los registros de la tabla GamesMedals son los resultados de cada championship y contiene al menos las tres primeros posiciones en cada prueba celebrada en el championship que se corresponden con los 3 medallistas
Los campos mas importantes de la tabla GamesMedals son: Season, Year, Championship, Discipline, Gender, Event, Position, Medal, Count, Team, Name, Country, Score. Proporciona información sobre las medallas obtenidas en todos los Juegos EYOF de la historia
- Season indica si los Juegos (Championship) son de verano (summmer) o invierno (winter)
- Discipline es el nombre de la disciplina, por ejemplo Athletics
- Gender es el genero de la prueba, Men o Boys, Women o Girls, Mixed, Open. Boys es igual que Men y Girls que Women.
- Event es el nombre de la prueba
- Position indica el puesto obtenido por el atleta en la prueba, es numerico. El valor1 es para la medalla de oro, el 2 para la medalla de plata y el 3 para la medalla de bronze.
- EvType indica si el evento es Individual o Team.
- Name es el nombre del atleta o del equipo (en eventos de equipos y count=1)
- Country es el nombre del pais 
- Score indica el resultado obtenido en el evento

Contexto Específico:
Resultados: Para preguntas sobre el resultado de una prueba en un championship responderas con los registros que cumplan con la condicion de la pregunta
Medallero: Para preguntas sobre el ranking de medallas, considera sólo registros donde el campo Count = 1. Y da el resultado ordenado por mas medallas de oro, mas medallas de plata y mas medallas de bronce salvo que te indiquen que ordenes por el total de medallas.
Medallistas: Para preguntas sobre los medallistas de una prueba responderas con todos los registros (Count = 0 y 1) que cumplan con la condicion de la pregunta.

Tipos de Juegos:
Games: 'EG' para Juegos Europeos (solo verano) y 'EYOF' para los Festivales Olímpicos de la Juventud Europea (verano e invierno).
Nota: Ajusta las consultas basándote en el tipo de evento, la categoría del evento y el género especificado, siempre que sea pertinente.

Question: {question}

"""

# 6. Función para hacer la consulta

def consulta(input_usuario):
    from langchain_community.tools.sql_database.tool import QuerySQLDataBaseTool

    question = formato.format(question = input_usuario)
    execute_query = QuerySQLDataBaseTool(db=db)
    write_query = create_sql_query_chain(llm, db)
    chain = write_query | execute_query

    from operator import itemgetter

    from langchain_core.output_parsers import StrOutputParser
    from langchain_core.prompts import PromptTemplate
    from langchain_core.runnables import RunnablePassthrough

    answer_prompt = PromptTemplate.from_template(
        """Given the following user question, corresponding SQL query, and SQL result, answer the user question.

    Question: {question}
    SQL Query: {query}
    SQL Result: {result}
    Answer: """
    )

    answer = answer_prompt | llm | StrOutputParser()
    chain = (
        RunnablePassthrough.assign(query=write_query).assign(
            result=itemgetter("query") | execute_query
        )
        | answer
    )

    resultado= chain.invoke({"question": question})
    print(resultado)
    return (resultado)


def consulta2(input_usuario):
    cadena =""
    consulta = formato.format(question = input_usuario)
    resultado = db.run(cadena.invoke({"question": consulta}))
    return(resultado)

def consulta1(input_usuario):
    from langchain_community.tools.sql_database.tool import QuerySQLDataBaseTool

    consulta = formato.format(question = input_usuario)
    execute_query = QuerySQLDataBaseTool(db=db)
    write_query = create_sql_query_chain(llm, db)
    cadena = write_query | execute_query
    resultado = cadena.invoke({"question": consulta})    
    #resultado = db.run(sentencia)
    return(resultado)
