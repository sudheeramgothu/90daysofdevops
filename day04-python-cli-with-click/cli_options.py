import click

@click.command()
@click.option("--name", prompt="Your name", default="World", help="The person to greet.")
@click.option("--caps", is_flag=True, help="Convert greeting to uppercase.")
def greet(name, caps):
    msg = f"Hello, {name}!"
    if caps:
        msg = msg.upper()
    click.echo(msg)

if __name__ == "__main__":
    greet()
