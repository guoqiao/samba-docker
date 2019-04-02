#!/usr/bin/env python3
import json
import subprocess
import click

SAMBA_REALM = 'samdom.example.com'

def check_output(cmd):
    return subprocess.check_output(cmd.split()).decode('utf-8').strip()


def check_call(cmd):
    return subprocess.check_call(cmd.split())


def dump_json(obj, indent=4, sort_keys=True):
    return json.dumps(obj, indent=indent, sort_keys=sort_keys)


class Domain:

    def __init__(self, *args, **kwargs):
        self.__dict__.update(**kwargs)

    def get_users(self, name_prefix='STGU-', ip_prefix="10.10"):
        users = []
        for i in range(self.users):
            name = '{}{}'.format(name_prefix, i)
            ip_parts = divmod(i, 255)
            user = {
                'index': i,
                'name': name,
                'domain': '{}.{}'.format(name, SAMBA_REALM),
                'wildcard_domain': '*.{}.{}'.format(name, SAMBA_REALM),
                'ip': '{}.{}.{}'.format(ip_prefix, ip_parts[0], ip_parts[1]),
            }
            users.append(user)
        return users


@click.command()
@click.option(
    '--users', 'users',
    default=5000,
    show_default=True,
    help='Number of users')
@click.option(
    '--groups-users-scale', 'groups_users_scale',
    default=0.1,
    show_default=True,
    help='Scale of groups to users')
@click.option(
    '--machines-users-scale', 'machines_users_scale',
    default=1.25,
    show_default=True,
    help='Scale of machines to users')
def main(*args, **kwargs):
    users = kwargs["users"]
    click.echo(message='users: {}'.format(users))

    groups_users_scale = kwargs["groups_users_scale"]
    groups = int(users * groups_users_scale)
    click.echo(message='groups: users * {} = {}'.format(groups_users_scale, groups))

    machines_users_scale = kwargs["machines_users_scale"]
    machines = int(users * machines_users_scale)
    click.echo(message='machines: users * {} = {}'.format(machines_users_scale, machines))

    domain = Domain(*args, **kwargs)
    users = domain.get_users()
    print(dump_json(users))


if __name__ == '__main__':
    main()
