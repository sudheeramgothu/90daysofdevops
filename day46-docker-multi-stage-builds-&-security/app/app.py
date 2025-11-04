from fastapi import FastAPI
app = FastAPI()
@app.get('/health')
def h(): return {'status':'ok'}
@app.get('/')
def root(): return {'service':'demo-api','version':'0.0.1'}
