import uvicorn, os
if __name__=='__main__': uvicorn.run('app:app', host='0.0.0.0', port=int(os.getenv('API_PORT','8080')), log_level='info')
