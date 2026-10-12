import os
import click
from app import create_app
from app.extensions import db
import app.models  # Ensure all models are registered with SQLAlchemy
from app.models.seed import seed_initial_data

# Instantiate application factory
app = create_app()
application = app

# Auto-initialize database tables and seeds when running on Vercel
if os.getenv("VERCEL"):
    with app.app_context():
        try:
            db.create_all()
            from app.models.auth import Role
            if not Role.query.first():
                seed_initial_data()
        except Exception as e:
            try:
                db.session.rollback()
            except Exception:
                pass
            app.logger.warning("Vercel DB initialization warning: %s", e)


@app.cli.command("init-db")
def init_db():
    """Create local database tables, indexes, and seed initial records."""
    with app.app_context():
        db.create_all()
        print("Database tables created successfully.")
        seed_initial_data()
        print("Foundational seeds inserted (Roles, Providers, Data Packages, Billers, Settings).")


@app.cli.command("seed-db")
def seed_db():
    """Seed foundational catalog, roles, and settings."""
    with app.app_context():
        seed_initial_data()
        print("Catalog, roles, and settings seeded successfully.")


@app.cli.command("show-tables")
def show_tables():
    """List all database tables and current record counts."""
    with app.app_context():
        inspector = db.inspect(db.engine)
        tables = inspector.get_table_names()
        print("=" * 60)
        print(f"DATABASE TABLES IN {app.config.get('APP_NAME').upper()}:")
        print("=" * 60)
        for t in sorted(tables):
            try:
                count = db.session.execute(db.text(f"SELECT COUNT(*) FROM `{t}`")).scalar()
                print(f" - {t:<28} : {count:>5} records")
            except Exception as e:
                print(f" - {t:<28} : Error ({e})")
        print("=" * 60)


@app.cli.command("check-config")
def check_config():
    """Display active application environment settings (safe view)."""
    print("=" * 60)
    print(f"System:           {app.config.get('APP_NAME')}")
    print(f"Environment Mode: {app.config.get('ENVIRONMENT_MODE')}")
    print(f"Is Sandbox:       {app.config.get('IS_SANDBOX')}")
    print(f"Debug Mode:       {app.config.get('DEBUG')}")
    print(f"Currency:         {app.config.get('CURRENCY')}")
    print(f"Country:          {app.config.get('COUNTRY')}")
    db_uri = str(app.config.get("SQLALCHEMY_DATABASE_URI"))
    masked_db = db_uri.split("@")[-1] if "@" in db_uri else db_uri
    print(f"Database Target:  {masked_db}")
    print("=" * 60)


@app.cli.command("auth-backup")
def auth_backup_cli():
    """Create an encrypted authentication database backup snapshot."""
    with app.app_context():
        from app.services.auth_backup_service import AuthBackupService
        res = AuthBackupService.create_auth_backup(initiated_by="CLI")
        print("=" * 60)
        print("AUTHENTICATION BACKUP CREATED:")
        print(f"File:     {res['filename']}")
        print(f"Path:     {res['file_path']}")
        print(f"Checksum: {res['checksum']}")
        print(f"Stats:    {res['stats']}")
        print("=" * 60)


@app.cli.command("auth-restore")
@click.argument("backup_file")
def auth_restore_cli(backup_file):
    """Restore authentication database from an encrypted backup snapshot file."""
    with app.app_context():
        from app.services.auth_backup_service import AuthBackupService
        res = AuthBackupService.restore_auth_backup(backup_file, dry_run=False)
        print("=" * 60)
        print("AUTHENTICATION BACKUP RESTORED:")
        print(f"Result: {res}")
        print("=" * 60)


if __name__ == "__main__":
    host = os.getenv("FLASK_HOST", "127.0.0.1")
    port = int(os.getenv("FLASK_PORT", 5000))
    debug = app.config.get("DEBUG", True)
    print(f"Starting {app.config.get('APP_NAME')} on http://{host}:{port} (Mode: {app.config.get('ENVIRONMENT_MODE')})")
    app.run(host=host, port=port, debug=debug)
