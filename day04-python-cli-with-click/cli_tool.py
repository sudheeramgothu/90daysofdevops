import click

@click.group()
def cli():
    pass

@cli.command()
@click.option("--name", default="World", help="The person to greet.")
def greet(name):
    click.echo(f"Hello, {name}!")

@cli.group()
def math():
    pass

@math.command()
@click.argument("a", type=int)
@click.argument("b", type=int)
def add(a, b):
    click.echo(f"{a} + {b} = {a+b}")

@math.command()
@click.argument("a", type=int)
@click.argument("b", type=int)
def div(a, b):
    if b == 0:
        click.echo("Error: Division by zero!")
    else:
        click.echo(f"{a} / {b} = {a/b}")

if __name__ == "__main__":
    cli()
