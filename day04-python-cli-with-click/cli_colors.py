import click

@click.group()
def cli():
    pass

@cli.command()
@click.option("--name", prompt="Your name", help="The person to greet.")
def greet(name):
    click.secho(f"Hello, {name}!", fg="green", bold=True)

@cli.group()
def math():
    pass

@math.command()
@click.argument("a", type=int)
@click.argument("b", type=int)
def div(a, b):
    try:
        result = a / b
        click.secho(f"{a} / {b} = {result}", fg="blue")
    except ZeroDivisionError:
        click.secho("Error: Cannot divide by zero!", fg="red", bold=True)

if __name__ == "__main__":
    cli()
